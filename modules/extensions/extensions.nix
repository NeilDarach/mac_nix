{
  den.aspects.extensions = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        options = with lib; {
          extensions = mkOption {
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
        config =
          let
            createEntries = lib.concatMapStrings (entry: ''
              ${pkgs.duti}/bin/duti -s ${entry.bundle} ${entry.uti} ${entry.role} > /dev/null
            '') config.extensions;
          in
          {
            home.activation.extensions = lib.mkIf (builtins.length config.extensions > 0) (
              lib.hm.dag.entryAfter [ "writeBoundry" ] ''
                echo >&2 "Setting up the extensions ..."
                ${createEntries}
              ''
            );
          };
      };
  };
}
