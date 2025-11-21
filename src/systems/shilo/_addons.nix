{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    settings.substituters = lib.mkForce [ "https://cache.nixos.org/" ];
  };

  environment.systemPackages = with pkgs; [
    janet
    emacs
    ocaml
    networkmanagerapplet
  ];

  services = {
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 60; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 90; # 80 and above it stops charging
      };
    };
  };

  virtualisation.docker.enable = false;

  systemd.network = {
    enable = true;

    wait-online = {
      enable = false;
    };

    networks = {
      "10-wireless" = {
        matchConfig = {
          Name = "wlo1";
        };

        linkConfig = {
          RequiredForOnline = "routable";
        };

        networkConfig = {
          DHCP = "yes";
          IgnoreCarrierLoss = "3s";
        };
      };

      "20-dock" = {
        matchConfig = {
          Name = "dock-enp0";
        };

        linkConfig = {
          RequiredForOnline = "no";
        };
      };
    };

    links = {
      "30-dock" = {
        matchConfig = {
          MACAddress = "e8:cf:83:d9:34:27";
        };

        linkConfig = {
          Name = "dock-enp0";
        };
      };

      "30-anker" = {
        matchConfig.MACAddress = "6c:6e:07:21:75:fe";
        linkConfig = {
          Description = "Anker dock";
          Name = "anker";
        };
      };

      "30-usbc" = {
        matchConfig = {
          MACAddress = "00:e0:4c:68:68:70";
        };

        linkConfig = {
          Name = "usbc";
        };
      };
    };
  };

  virtualisation.libvirtd.allowedBridges = lib.lists.genList (
    x: "br" + "${(builtins.toString x)}"
  ) 1000;

  # has to be built onetime first?
  sops.secrets.whn = { };

  networking = {
    enableIPv6 = false;
    hostName = builtins.readFile "${config.sops.secrets.whn.path}";
    networkmanager = {
      enable = true;
    };
    #wireless = {
    #  iwd.enable = true;
    #};

    firewall.enable = false;
  };
}
