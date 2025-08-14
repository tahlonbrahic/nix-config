{pkgs, ...}: {
  nix = {
    #settings.substituters = lib.mkForce ["https://cache.nixos.org/"];
    #distributedBuilds = true;
    #buildMachines = [
    #  {
    #    hostName = "192.168.5.36";
    #    speedFactor = 10;
    #    system = "x86_64-linux";
    #    maxJobs = 8;
    #  }
    #];
  };

  sops.secrets.authenticationTokenConfigFile = {
  };

  services = {
    atftpd = {
      #enable = true;
      root = "/srv/tftp";
      extraOptions = [
        "--bind-address 192.168.100.10"
        "--verbose=7"
      ];
    };

    # SOCKS5 proxy
    dante = {
      enable = true;
      config = ''
        logoutput: stdout
        errorlog: stderr

        internal: 0.0.0.0 port = 3128
        external: eth0

        clientmethod: none
        socksmethod: none

        client pass {
                from: 0.0.0.0/0 to: 0.0.0.0/0
                log: error connect disconnect
        }
        socks pass {
                from: 0.0.0.0/0 to: 0.0.0.0/0
                log: error connect disconnect
        }
      '';
    };

    gitlab-runner = {
      enable = true;

      services.nix-runner = {
        #enable = true;
        description = "Nix Runner";

        registrationFlags = [
          "--docker-volumes-from"
          "gitlabnix:ro"

          "--docker-pull-policy"
          "if-not-present"

          "--docker-allowed-pull-policies"
          "if-not-present"
        ];

        #authenticationTokenConfigFile = config.sops.secrets.authenticationTokenConfigFile.path;

        executor = "docker";

        dockerImage = "local/nix:latest";
        dockerAllowedImages = ["local/nix:latest"];

        environmentVariables = {
          NIX_REMOTE = "daemon";
          ENV = "/etc/profile.d/nix-daemon.sh";
          BASH_ENV = "/etc/profile.d/nix-daemon.sh";
        };

        preBuildScript = ''
          mkdir -p /tmp

          # We need to allow modification of nix config for cachix as
          # otherwise it is link to the read only file in the store.
          cp --remove-destination \
            $(readlink -f /etc/nix/nix.conf) /etc/nix/nix.conf
        '';
      };
    };
  };

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

      "20-devnet" = {
        matchConfig = {
          Name = "devnet";
        };

        linkConfig = {
          RequiredForOnline = "no";
        };

        address = [
          "192.168.5.20/24"
          "192.168.1.11/24"
        ];
      };
    };

    links = {
      "30-dock" = {
        matchConfig = {
          MACAddress = "e8:cf:83:d9:34:27";
        };

        linkConfig = {
          Description = ''
            Dell dock ethernet interface, primarily used for plugging into a dumb-switch.
          '';
          Name = "dock-enp0";
        };
      };

      "30-devnet" = {
        matchConfig = {
          MACAddress = "00:e0:4c:68:68:70";
        };

        linkConfig = {
          Description = ''
            USB-C to Ethernet adapter used to plug into vm/physical development network.
            Networkd dispatcher will automatically build and remove bridges when this is detected and not.
          '';
          Name = "devnet";
        };
      };
    };
  };

  virtualisation.libvirtd.allowedBridges = [
    "br221"
    "br222"
    "br223"
    "br224"
    "br231"
    "br232"
    "br233"
    "br234"
    "br241"
    "br242"
    "br243"
    "br244"
    "br251"
    "br252"
    "br253"
    "br254"
    "br261"
    "br262"
    "br263"
    "br264"
    "br271"
    "br272"
    "br273"
    "br274"
    "br281"
    "br282"
    "br283"
    "br284"
  ];

  networking = {
    enableIPv6 = false;
    hostName = "SSCLAPTOP024";
    networkmanager = {
      enable = true;
    };
    wireless = {
      iwd.enable = true;
    };

    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
    iwgtk
    (pkgs.writeShellApplication {
      name = "enable-local-devnet";
      runtimeInputs = with pkgs; [iproute2 wirelesstools sudo];
      excludeShellChecks = [
        "SC2086"
        "SC2153"
        "SC2154"
      ];
      text = ''
           echo "Creating VM Bridges"
           iface="devnet"
           toBridge1=(211 212)
           toBridge2=(221 231)

           create_bridges () {
             echo "Creating br$BR and tying $iface.$BR to it"
             sudo ip link add link $iface name $iface.$BR type vlan id $BR
             sudo ip link set $iface.$BR up
             sudo ip link add br$BR type bridge
             sudo ip link set br$BR up
             sudo ip link set $iface.$BR master br$BR
           }

           for BR in 211 212 213 214 221 222 223 224 231 232 233 234 241 242 243 244 251 252 253 254 261 262 263 264 271 272 273 274
           do
             create_bridges
           done

           for i in $(seq 0 $((''\${#toBridge1[@]} - 1)));
           do
             echo "Connecting br''\${toBridge1[$i]} and br''\${toBridge2[$i]} via vm''\${toBridge1[$i]}''\${toBridge2[$i]} and vm''\${toBridge2[$i]}''\${toBridge1[$i]}"
        sudo ip link add dev vm"''\${toBridge1[$i]}""''\${toBridge2[$i]}" type veth peer name vm"''\${toBridge2[$i]}""''\${toBridge1[$i]}"
        sudo ip link set dev vm"''\${toBridge1[$i]}""''\${toBridge2[$i]}" up
        sudo ip link set vm"''\${toBridge1[$i]}""''\${toBridge2[$i]}" master br"''\${toBridge1[$i]}"
        sudo ip link set dev vm"''\${toBridge2[$i]}""''\${toBridge1[$i]}" up
        sudo ip link set vm"''\${toBridge2[$i]}""''\${toBridge1[$i]}" master br"''\${toBridge2[$i]}"
           done

           exit 0
      '';
    })
    (pkgs.writeShellApplication {
      name = "disable-local-devnet";
      runtimeInputs = with pkgs; [iproute2 wirelesstools sudo];
      excludeShellChecks = [
        "SC2086"
        "SC2153"
        "SC2154"
      ];
      text = ''
        echo "Destroying VM Bridges"
        iface="devnet"
        toBridge1=(211 212)
        toBridge2=(221 231)
        for i in $(seq 0 $((''\${#toBridge1[@]} - 1)));
        do
          echo "Disconnecting br''\${toBridge1[$i]} and br''\${toBridge2[$i]} by deleting vm''\${toBridge1[$i]}''\${toBridge2[$i]} and vm''\${toBridge2[$i]}''\${toBridge1[$i]}"
           sudo ip link del vm''\${toBridge1[$i]}''\${toBridge2[$i]}
        done

        destroy_bridges () {
          echo "Removing $iface.$BR and deleting br$BR"
           sudo ip link del $iface.$BR
           sudo ip link del br$BR
        }

        for BR in 211 212 213 214 221 222 223 224 231 232 233 234 241 242 243 244 251 252 253 254 261 262 263 264 271 272 273 274
        do
          destroy_bridges
        done

        exit 0
      '';
    })
    (pkgs.writeShellApplication {
      name = "enable-devnet";
      runtimeInputs = with pkgs; [iproute2 wirelesstools sudo];
      excludeShellChecks = [
        "SC2086"
        "SC2153"
        "SC2154"
      ];
      text = ''
        echo "Creating VM Bridges"
        iface="devnet"

        create_bridges () {
          echo "Creating br$BR and tying $iface.$BR to it"
          sudo ip link add link $iface name $iface.$BR type vlan id $BR
          sudo ip link set $iface.$BR up
          sudo ip link add br$BR type bridge
          sudo ip link set br$BR up
          sudo ip link set $iface.$BR master br$BR
        }

        for BR in 211 212 213 214 221 222 223 224 231 232 233 234 241 242 243 244 251 252 253 254 261 262 263 264 271 272 273 274 281 282 283 284 291 292 293 294
        do
          create_bridges
        done

        exit 0
      '';
    })
    (pkgs.writeShellApplication {
      name = "disable-devnet";
      runtimeInputs = with pkgs; [iproute2 wirelesstools sudo];
      excludeShellChecks = [
        "SC2086"
        "SC2153"
        "SC2154"
      ];
      text = ''
        echo "Destroying VM Bridges"
        iface="devnet"

        destroy_bridges () {
          echo "Removing $iface.$BR and deleting br$BR"
           sudo ip link del $iface.$BR
           sudo ip link del br$BR
        }

        for BR in 211 212 213 214 221 222 223 224 231 232 233 234 241 242 243 244 251 252 253 254 261 262 263 264 271 272 273 274 281 282 283 284 291 292 293 294
        do
          destroy_bridges
        done

        exit 0
      '';
    })
  ];
}
