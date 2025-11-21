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

    networking.nameservers = lib.mkForce ["10.0.1.1"];
    #systemd.network.networks."25-wireless".dns = lib.mkForce ["10.0.1.1"];

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
        enable = false;
        additionalWhistelistedInterfaces = ["wlp7s0"];
        home.pci = "pci-0000:07:00.0*";
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
