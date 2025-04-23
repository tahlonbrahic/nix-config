{
  inputs,
  outPath,
  lib,
  ...
}: {
  config = {
    networking.networkmanager.enable = true;

    services.tailscale = {
      enable = true;
    };

    security.pam.services.hyprlock = {};

    frostbite = {
      display.design.theme = "${inputs.assets}/themes/nord.yaml";
      support.laptop = {
        enable = true;
        enableHyprlandSupport = true;
      };
      services.ssh = {
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
        ];
      };
      security = {
        secrets.defaultSopsFile = outPath + "/src/secrets/secrets.yaml";
        useCase = "laptop";
        yubikey.enable = true;
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
        #test = {};
      };
    };
  };
}
