{
  den.aspects.etcd = {
    nixos = {
      services.etcd = {
        enable = true;
        name = "etcd";
        advertiseClientUrls = [ "http://etcd.darach.org.uk:2379" ];
        listenClientUrls = [ "http://0.0.0.0:2379" ];
        listenPeerUrls = [ "http://0.0.0.0:2380" ];
        initialAdvertisePeerUrls = [ "http://etcd.darach.org.uk:2380" ];
        initialCluster = [ "etcd=http://etcd.darach.org.uk:2380" ];
        openFirewall = true;
        extraConf = {
          "AUTO_COMPACTION_RETENTION" = "1";
        };
      };
    };
  };
}
