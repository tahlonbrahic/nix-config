{
  inputs,
  outPath,
  pkgs,
  lib,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [wl-gammarelay-applet];
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "valid users" = "tahlon";
          "hosts allow" = "192.168.1.91 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/home/tahlon/Documents";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "username";
          "force group" = "groupname";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    services.tailscale = {
      enable = true;
    };

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

      networks.enable = false;

      users.users = {
        tahlon = {
          isAdministrator = lib.mkForce true;
        };
      };
    };
  };
}
