{
  inputs,
  outPath,
  lib,
  ...
}: {
  config = {
    system.includeBuildDependencies = lib.mkForce false;

    services = {
      resolved.extraConfig = ''
        [Resolve]
        DNS=10.0.1.1
        Domains=~family
      '';

      inputplumber.enable = true;
    };

    programs = {
      opengamepadui = {
        enable = true;
        #gamescopeSession = {
        #  enable = true;
        #};
        #powerstation.enable = true;
      };
    };

    security.pam.services.hyprlock = {};

    frostbite = {
      display = {
        design.theme = "${inputs.assets}/themes/nord.yaml";
      };
      services.ssh = {
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
        ];
      };
      support.nvidia.enable = true;
      gaming.steam.enable = true;
      security = {
        secrets.defaultSopsFile = outPath + "/src/secrets/secrets.yaml";
        useCase = "workstation";
        yubikey.enable = false;
      };

      networks.wireless = {
        enable = true;
        additionalWhistelistedInterfaces = ["wlp7s0"];
        home = {
          SSID = "ATTp4pQVS2";
          gateway = "192.168.1.254";
          staticIP = "192.168.1.101/24";
          pci = "pci-0000:07:00.0*";
        };
      };

      users = {
        globalIntialPassword = "p";
        users = {
          tahlon = {
            isAdministrator = lib.mkForce true;
          };
        };
      };
    };
  };
}
