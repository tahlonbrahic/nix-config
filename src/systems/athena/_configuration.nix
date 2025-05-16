{
  inputs,
  outPath,
  lib,
  ...
}: {
  config = {
    system.includeBuildDependencies = lib.mkForce false;
    networking.networkmanager.enable = true;

    services.tailscale = {
      enable = true;
    };

    security.pam.services.hyprlock = {};

    frostbite = {
      display.design.theme = "${inputs.assets}/themes/nord.yaml";
      services.ssh = {
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
        ];
      };
      gaming.steam.enable = true;
      security = {
        secrets.defaultSopsFile = outPath + "/src/secrets/secrets.yaml";
        useCase = "workstation";
        yubikey.enable = false;
        SELinux.enable = false;
      };

      networking = {
        enable = false;
        firewall.enable = false;
        fail2ban.enable = false;
      };

      users.users = {
        tahlon = {
          isAdministrator = lib.mkForce true;
        };
      };
    };
  };
}
