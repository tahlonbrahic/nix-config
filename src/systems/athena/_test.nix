{config, ...}: {
  networking.nat = {
    enable = true;
  };

  users = {
    groups = {
      nextcloud = {};
    };

    users = {
      nextcloud = {
        isNormalUser = false;
        isSystemUser = true;
        group = "nextcloud";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/nextcloud 0750 nextcloud nextcloud" # nextcloud container
  ];

  containers = {
    nextcloud = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = false;
      macvlans = ["wireless"];
      bindMounts = {
      };

      config = {pkgs, ...}: {
        services.nextcloud = {
          package = pkgs.nextcloud30;
          enable = true;
          home = "/var/lib/nextcloud";
          config = {
            adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
            dbtype = "sqlite";
          };
          hostName = "testguy";
        };

        networking = {
          useDHCP = false;
          useNetworkd = true;
          useHostResolvConf = false;
        };

        systemd.network = {
          enable = true;
          networks."40-mv-wireless" = {
            matchConfig.Name = "mv-wireless";
            address = [
              "192.168.1.16/24"
            ];
            networkConfig.DHCP = "yes";
            dhcpV4Config.ClientIdentifier = "mac";
          };
        };

        system.stateVersion = "23.11";
      };
    };
  };
}
