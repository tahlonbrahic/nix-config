{
  inputs,
  outPath,
  pkgs,
  lib,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [ wl-gammarelay-applet ];

    services = {
      resolved.extraConfig = ''
        [Resolve]
        DNS=10.0.1.1
        Domains=~family
      '';

      inputplumber.enable = true;
    };

    networking.nameservers = lib.mkForce [ "10.0.1.1" ];
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

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
      };

      users.users = {
        tahlon = {
          isAdministrator = lib.mkForce true;
        };
      };
    };
  };
}
