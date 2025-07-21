{
  inputs,
  outPath,
  pkgs,
  lib,
  ...
}: {
  config = {
    system.includeBuildDependencies = lib.mkForce false;

    security.pam.services.hyprlock = {};

    environment.systemPackages = with pkgs; [celluloid vlc];

    frostbite = {
      display.design.theme = "${inputs.assets}/themes/nord.yaml";
      services.ssh = {
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaAoWr+wZLiVmfTXCby8eriQ62jqqnqxCaenopHKwHY"
        ];
      };
      security = {
        secrets.defaultSopsFile = outPath + "/src/secrets/secrets.yaml";
        useCase = "laptop";
        yubikey.enable = false;
      };

      support.laptop = {
        enable = true;
        enableHyprlandSupport = true;
      };

      users = {
        users = {
          tahlon = {
            isAdministrator = true;
          };
        };
      };
    };
  };
}
