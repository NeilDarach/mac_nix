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
  };
}
