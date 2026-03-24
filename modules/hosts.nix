# defines all hosts + users + homes.
# then config their aspects in as many files you want
{ den, ... }:
{
  flake.den = den;
  den.hosts.aarch64-darwin.NeilsMacBookPro = {
    users.neil = {
      classes = [ "homeManager" ];
    };
    users.marion = {
      classes = [ "homeManager" ];
    };
  };
  den.hosts.aarch64-linux.r5s = {
    users.neil = {
      classes = [ "homeManager" ];
    };
    users.root = {
      classes = [ "homeManager" ];
    };
  };
  den.hosts.aarch64-linux.r5s-sd = {
    users.nix.classes = [ "homeManager" ];
  };
  den.hosts.x86_64-linux.gregor = {
    users.neil = {
      classes = [ "homeManager" ];
    };
    users.root = {
      classes = [ "homeManager" ];
    };
  };
  den.hosts.x86_64-linux.goip = {
    users.neil = {
      classes = [ "homeManager" ];
    };
    users.root = {
      classes = [ "homeManager" ];
    };
    users.backup = { };
  };
}
