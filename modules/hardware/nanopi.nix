{local,...}: {
  local.hardware = {
    includes = [ local.nanopi-r8125 ];
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.nanopi-r5s;
      in
      {
        options = with lib; {
          nanopi-r5s = {
            nics = mkOption {
              type = types.listOf (types.attrsOf types.str);
              default = [
                {
                  name = "wan0";
                  path = "platform-fe2a0000.ethernet";
                }
                {
                  name = "lan1";
                  path = "platform-3c000000.pcie-*";
                }
                {
                  name = "lan2";
                  path = "platform-3c040000.pcie-*";
                }
              ];
              description = "The default names and identifiers of the network interfaces";
            };

            bootloader = {
              dtb = mkOption {
                type = types.str;
                default = "rockchip/rk3568-nanopi-r5s.dtb";
                description = "The device file to use when booting";
              };
              url = mkOption {
                type = types.str;
                default = "https://github.com/inindev/u-boot-build/releases/download/2025.01/rk3568-nanopi-r5s.zip";
              };
              hash = mkOption {
                type = types.str;
                default = "sha256-ZJYM1sjaS0wCQPqKuP8HxmqXpy+eaSyjvMnWakTvZ80=";
                description = "The hash of the file in bootloader.url";
              };
            };
            network.interfaces = listToAttrs (
              map (
                nic:
                nameValuePair nic.name {
                  name = mkOption {
                    type = types.str;
                    default = nic.name;
                    description = "Interface name for ${nic.name}";
                  };
                  mac = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Mac address for ${nic.name}, if unset a random address will be created on boot";
                  };
                }
              ) cfg.nics
            );
          };
        };
        config = {
          hardware = {
            firmware = [ pkgs.linux-firmware ];
            deviceTree.name = cfg.bootloader.dtb;
          };
          boot = {
            kernelParams = [
              "console=tty0"
              "earlycon=uart8250,mmio32,0xfe660000"
            ];
            initrd.kernelModules = [
              "sdhci_of_dwcmshc"
              "dw_mmc_rockchip"
              "analogix_dp"
              "io-domain"
              "rockchip_saradc"
              "rockchip_thermal"
              "rockchipdrm"
              "rockchip-rga"
              "pcie_rockchip_host"
              "phy-rockchip-pcie"
              "phy_rockchip_snps_pcie3"
              "phy_rockchip_naneng_combphy"
              "phy_rockchip_inno_usb2"
              "dwmac_rk"
              "dw_wdt"
              "dw_hdmi"
              "dw_hdmi_cec"
              "dw_hdmi_i2s_audio"
              "dw_mipi_dsi"
            ];

            loader = {
              grub.enable = false;
              generic-extlinux-compatible = {
                enable = true;
                useGenerationDeviceTree = true;
              };
              timeout = 1;
            };
          };

          powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

          systemd.network.links = builtins.listToAttrs (
            map (
              nic:
              let
                opts = cfg.network.interfaces.${nic.name};
              in
              lib.nameValuePair "10-${nic.name}" {
                matchConfig = {
                  Path = nic.path;
                };
                linkConfig = {
                  Name = opts.name;
                }
                // (
                  if (opts.mac != null) then
                    {
                      MACAddress = opts.mac;
                    }
                  else
                    { }
                );
              }
            ) cfg.nics
          );

          systemd.services."irqbalance-oneshot" = {
            enable = true;
            description = "Distribute interrupts after booting using 'irqbalance --oneshot'";
            documentation = [ "man:irqbalance" ];
            wantedBy = [ "sysinit.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.irqbalance}/bin/irqbalance --foreground --oneshot";
            };
          };
        };
      };
  };
}
