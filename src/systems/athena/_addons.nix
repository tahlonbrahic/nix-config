{
  config,
  pkgs,
  ...
}: {
  systemd.tmpfiles.rules = [
    "Z /var/lib/hass/custom_components 770 hass hass - -"
    "f ${config.services.home-assistant.configDir}/automation.yaml 0755 hass hass"
  ];

  # All built on 25.05
  services.home-assistant = {
    enable = true;
    configWritable = true;
    config = {
      default_config = {};
      "automation ui" = "!include automation.yaml";
    };
    customComponents = with pkgs.home-assistant-custom-components; [
      alarmo
      waste_collection_schedule
      smartthinq-sensors
    ];

    lovelaceConfigWritable = true;
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      # docs: custom cards and ui stuff other people made
      weather-card
      #   versatile-thermostat-ui-card
      mushroom
      #   light-entity-card
      #   advanced-camera-card
      card-mod
      vacuum-card
    ];

    # for documentation later, these are just shits u wanna add on to your setup
    extraComponents = [
      "aep_ohio"
      "amcrest" # still have to modify this in configuration.yaml :(
      "androidtv"
      "android_ip_webcam"
      "androidtv"
      "aws"
      "bluetooth_adapters"
      "climate"
      "button"
      "calendar"
      "cast"
      "config"
      "date"
      "deluge"
      "default_config"
      "esphome"
      "fire_tv"
      "generic"
      "google"
      "google_assistant"
      "google_generative_ai_conversation"
      "govee_light_local"
      "http"
      "input_button"
      "input_datetime"
      "input_number"
      "input_select"
      "input_text"
      "ios"
      "lg_thinq" # integration for lq smart devices
      "life360"
      "linode"
      "local_file"
      "local_ip"
      "met"
      "mobile_app"
      "mullvad"
      "roomba"
      "route53"
      "spotify"
      "tesla_fleet" # using myteslamate for free api ;)
      "todo"
      "tts"
      "usb"
      "vacuum"
      "wake_word"
      "zwave_js"
    ];
  };

  # mqtt for home-assistant
  services.mosquitto = {
    enable = true;

    # unsafe but for testing
    listeners = [
      {
        acl = ["pattern readwrite #"];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  services.matter-server.enable = true;

  programs.kdeconnect.enable = true;

  services.plex.enable = true;

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

  services.zwave-js = {
    enable = true;
    serialPort = "/dev/ttyACM0";
    secretsConfigFile = "/var/lib/zwave/secrets";
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--exit-node-allow-lan-access"
      "--advertise-routes=192.168.1.0/24"
      "--accept-routes"
    ];
  };
}
