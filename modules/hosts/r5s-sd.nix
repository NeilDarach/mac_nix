{ den, inputs, self,... }:
{
  den.aspects.r5s-sd = {
    includes = with den.aspects; [
      zfs
      hardware._.nanopi-r5s
   den._.self'
    ];
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        boot = {
          growPartition = true;
          postBootCommands =
            let
              nixPathRegistrationFile = "/nix-path-registration";
            in
            ''
              # On the first boot do some maintenance tasks
              if [ -f ${nixPathRegistrationFile} ]; then
                set -euo pipefail
                set -x

                # Figure out device names for the boot device and root filesystem.
                rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
                bootDevice=$(lsblk -npo PKNAME $rootPart)

                # Resize the root partition and the filesystem to fit the disk
                echo ",+," | sfdisk -N1 --no-reread $bootDevice
                ${pkgs.parted}/bin/partprobe
                ${pkgs.e2fsprogs}/bin/resize2fs $rootPart

                # Register the contents of the initial Nix store
                ${config.nix.package.out}/bin/nix-store --load-db < ${nixPathRegistrationFile}

                # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
                touch /etc/NIXOS
                ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

                # Prevents this from running on later boots.
                rm -f ${nixPathRegistrationFile}
              fi

            '';
        };
        fileSystems = {
          "/" = {
            device = "/dev/disk/by-label/NIXOS";
            fsType = "ext4";
          };
          "/var/log" = {
            fsType = "tmpfs";
          };
        };
        boot.tmp.useTmpfs = true;
        networking = {
          hostName = lib.mkForce "nixos";
          useDHCP = lib.mkForce true;
          hostId = "d9165afe";
        };

        environment.systemPackages = with pkgs; [
          git
          python3
          mc
          psmisc
          curl
          wget
          dig
          file
          nvd
          ethtool
          sysstat
          dnsutils
          neovim
          jq
          unzip
          usbutils
          lsof
        ];

        users.users.nix = {
          isNormalUser = true;
          description = "nix";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          password = "nix";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJ0nGtONOY4QnJs/xj+N4rKf4pCWfl25BOfc8hEczUg neil.darach@gmail.com"
          ];
        };
        services.openssh.enable = true;

      };
  };
  perSystem =
    { pkgs, ... }:
    let
      image = self.nixosConfigurations.r5s-sd;
      bootloader = pkgs.stdenvNoCC.mkDerivation {
        name = "nanopi-r5s-loader";
        src = pkgs.fetchurl {
          url = image.config.nanopi-r5s.bootloader.url;
          hash = image.config.nanopi-r5s.bootloader.hash;
        };
        nativeBuildInputs = [ pkgs.unzip ];
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;

        unpackPhase = ''
          unzip $src -d src
        '';
        installPhase = ''
          mkdir -p $out
          cp src/idbloader.img $out/idbloader.img
          cp src/u-boot.itb $out/u-boot.itb
        '';
      };
    in
    {
      packages = {
        nanopi-r5s-image = pkgs.stdenv.mkDerivation {
          inherit bootloader;
          name = "nanopi-r5s-nixos";
          nativeBuildInputs = with pkgs; [
            e2fsprogs
            util-linux
            xz
          ];
          rootfsImage = pkgs.callPackage "${toString inputs.nixpkgs}/nixos/lib/make-ext4-fs.nix" {
            storePaths = image.config.system.build.toplevel;
            populateImageCommands = ''
              mkdir -p ./files/boot
              mkdir -p ./files/etc/nixos
              ${image.config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${image.config.system.build.toplevel} -d ./files/boot
              mkdir -p ./files/u-boot
              cp ${bootloader}/idbloader.img ./files/u-boot 
              cp ${bootloader}/u-boot.itb ./files/u-boot
              echo "dd conv=notrunc if=/u-boot/idbloader.img seek=8 of=/dev/??" > ./files/u-boot/readme.txt
              echo "dd conv=notrunc if=/u-boot/u-boot.itb seek=2048 of=/dev/??" >> ./files/u-boot/readme.txt
            '';
            volumeLabel = "NIXOS";
          };
          buildCommand = ''
            mkdir $out
            img=tmp.img
            #gap in front of the root partition (to fit uboot)
            gap=16
            #create the image file sized to fit bootloader, / and the gap
            rootSizeBlocks=$(du -B 512 --apparent-size $rootfsImage | awk '{ print $1 }')
            imageSize=$((rootSizeBlocks *512 + gap *1024 *1024))
            truncate -s $imageSize $img

            sfdisk --no-reread --no-tell-kernel $img <<EOF
              label: dos
              start=''${gap}M, type=83, bootable
            EOF

            eval $(partx $img -o START,SECTORS --nr 1 --pairs)
            dd conv=notrunc of=$img if=$rootfsImage seek=$START count=$SECTORS
            dd conv=notrunc of=$img if=${bootloader}/idbloader.img seek=8 
            dd conv=notrunc of=$img if=${bootloader}/u-boot.itb seek=2048 
            xz -vc $img > $out/nanopi-r5s-nixos.img.xz
            xz -t $out/nanopi-r5s-nixos.img.xz
          '';
        };
      };
    };
}
