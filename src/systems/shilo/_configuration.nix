{
  inputs,
  outPath,
  pkgs,
  lib,
  ...
}:
{
  config = {
    virtualisation.lxc.enable = true;
    system.includeBuildDependencies = lib.mkForce false;
    programs.fish.enable = true;
    environment.systemPackages = with pkgs; [
      celluloid
      vlc
      dhcpcd
      gdb
      cgdb
      bic
      zig
      gh
    ];

    services.fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    users.users.tahlon.hashedPassword = lib.mkForce "$y$j9T$i1JVbvAcAMdJWbai7DbQw/$1vMC5R29DUcepcCZlUjhch0E6E5OwbKi8jZJI3e2s3D";

    frostbite = {
      #  services.ssh = {
      #    publicKeys = [
      #      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
      #      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaAoWr+wZLiVmfTXCby8eriQ62jqqnqxCaenopHKwHY"
      #    ];
      #  };
      networking.bluetooth.enable = false;

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
