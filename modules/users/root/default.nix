{
  den.aspects.root = {
    homeManager-nixos =
      {
        home = {
          sessionVariables = {
            PAGER = "less";
            CLICOLOR = 1;
            EDITOR = "vim";
          };
          shellAliases = {
            cat = "bat";
            less = "bat";
          };
          file.".ssh/system_known_hosts" = {
            text = "";
          };
        };
        programs = {
          ssh = {
            enable = true;
            enableDefaultConfig = false;
            matchBlocks = {
              "*" = {
                userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/system_known_hosts";
              };
            };
          };
          bash.enable = true;
        };
      };
  };
}
