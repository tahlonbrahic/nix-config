{
  config,
  pkgs,
  ...
}: {
  # mqtt for home-assistant
  #services.mosquitto = {
  #  enable = true;
  #
  #  # unsafe but for testing
  #  listeners = [
  #    {
  #      acl = ["pattern readwrite #"];
  #      omitPasswordAuth = true;
  #      settings.allow_anonymous = true;
  #    }
  #  ];
  #};

  services.logind = {
    powerKey = "ignore";
    rebootKey = "ignore";
    hibernateKey = "ignore";
  };

  #services.matter-server.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  programs.kdeconnect.enable = true;

  services.syncthing = {
    enable = true;
    user = "syncthing";
    group = "users";
    dataDir = "/var/lib/syncthing";
    configDir = "/var/lib/syncthing/config";
    databaseDir = "/var/lib/syncthing/database";
    settings = {
      devices = {
        "idiopathic" = {
          id = "G46LA7T-3U2T5Q5-MMVWKDJ-AT6V63E-52WRPLT-F5X667N-YGPOVEQ-AMUF4AR";
          autoAcceptFolders = true;
        };
      };
      folders = {
      };
      options = {
        # urAccepted = false;
      };
    };
  };

  # services.zwave-js = {
  #   enable = true;
  #   serialPort = "/dev/ttyACM0";
  #   secretsConfigFile = "/var/lib/zwave/secrets";
  # };

  services.mullvad-vpn.enable = true;
  environment.systemPackages = with pkgs; [drawio quickemu satisfactorymodmanager cura-appimage arduino openscad blender librecad chromium monero-gui xmrig tor-browser];

  services.pcscd.enable = true;
  users.users.tahlon.extraGroups = ["dialout"];
}
