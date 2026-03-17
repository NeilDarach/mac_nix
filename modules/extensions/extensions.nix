{
  den.default.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = with lib; {
        local.extensions = {
          enable = mkOption {
            description = "Modify application associations";
            default = pkgs.stdenv.isDarwin;
            example = false;
            type = types.bool;
          };
          entries = mkOption {
            description = "App types to update";
            default = [ ];
            type =
              with types;
              listOf (submodule {
                options = {
                  uti = mkOption { type = str; };
                  bundle = mkOption { type = str; };
                  role = mkOption {
                    type = str;
                    default = "all";
                  };
                };
              });
          };
        };
      };
      config =
        let
          cfg = config.local.extensions;
        in
        lib.mkIf cfg.enable (
          let
            createEntries = lib.concatMapStrings (entry: ''
              ${pkgs.duti}/bin/duti -s ${entry.bundle} ${entry.uti} ${entry.role} > /dev/null
            '') cfg.entries;
          in
          {
            home.activation.extensions = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
              echo >&2 "Setting up the extensions ..."
              ${createEntries}
            '';
          }
        );
    };
}
