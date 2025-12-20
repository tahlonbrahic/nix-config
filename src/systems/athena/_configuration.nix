{
  inputs,
  outPath,
  lib,
  ...
}:
{
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

    networking.nameservers = lib.mkForce [ "10.0.1.1" ];

    programs = {
      opengamepadui = {
        enable = true;
      };
      fish.enable = lib.mkForce true;
    };

    security.pam.services.hyprlock = { };

    frostbite = {
      # services.ssh = {
      #  publicKeys = [
      #    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
      #  ];
      # };
      support.nvidia.enable = true;
      gaming = {
        steam.enable = true;
        monitoring.enable = true;
        #kernel.enable = true;
        emulation.enable = false;
        launchers.enable = true;
      };
      security = {
        secrets.defaultSopsFile = outPath + "/src/secrets/secrets.yaml";
        useCase = "workstation";
        yubikey.enable = false;
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
