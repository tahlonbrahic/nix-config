{
  pkgs,
  lib,
  ...
}: {
  networking = {
    usePredictableInterfaceNames = true;
    # allowAuxiliaryImperativeNetworks = true;
    nameservers = ["8.8.8.8"];
    tempAddresses = "disabled";
    enableIPv6 = false;
    wireless = {
      iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = false;
            RoutePriorityOffset = 300;
            NameResolvingService = "systemd";
          };
          Settings = {
            AutoConnect = true;
          };
        };
      };
      interfaces = ["wlan0" "wireless"];
    };
  };

  environment.systemPackages = [pkgs.iwgtk];

  services.resolved.enable = true;

  systemd.network = {
    enable = true;
    wait-online.enable = false;

    links = {
      "10-rename-wlo1" = {
        matchConfig.Path = "pci-0000:00:14.3*";
        linkConfig.Name = "wireless";
      };
    };

    networks = {
      "25-wireless-static" = {
        matchConfig = {
          Name = "wireless";
          SSID = "ATTp4pQVS2";
        };
        address = ["192.168.1.42/24"];
        routes = [
          {Gateway = "192.168.1.254";}
        ];
        dns = ["8.8.8.8"];
        networkConfig = {
          DHCP = "no";
          LinkLocalAddressing = "no";
        };
      };
    };
  };
}
