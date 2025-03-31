{
  inputs,
  lib,
  ...
}: {
  config = {
    system.includeBuildDependencies = lib.mkForce false;
    networking.hostName = "athena";
    users.users.tahlon.group = "tahlon";
    users.groups.tahlon = {};
    users.users.tahlon.isSystemUser = true;
    frostbite = {
      display.design.theme = "${inputs.assets}/themes/nord.yaml";
      # email.address = "tahlonbrahic@proton.me";
      #home-assistant = {
      #  enable = true;
      #  email = "tahlonbrahic@proton.me";
      #  domain = "home.brahic.family";
      #  #fqdn = "hass.brahic.family";
      #};
      services.ssh = {
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
        ];
      };
      security = {
        useCase = "workstation";
        yubikey.enable = false;
      };
      networking.firewall.enable = false;
      users.accounts = [
        "tahlon"
      ];
    };
  };
}
