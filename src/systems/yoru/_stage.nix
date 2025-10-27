{
  lib,
  pkgs,
  ...
}: {
  networking.nameservers = lib.mkForce ["192.168.1.53" "1.1.1.1"];
  networking.search = ["brahic.family"];
  systemd.network.networks."25-wireless".dns = lib.mkForce ["192.168.1.53" "1.1.1.1"];
  systemd.network.networks."25-wireless".domains = lib.mkForce ["brahic.family"];
  services.resolved.dnssec = lib.mkForce "false";
  frostbite.networks.wireless = {
    enable = true;
    home = {
      pci = "pci-0000:00:14.3*";
      SSID = "ATTp4pQVS2";
      staticIP = "192.168.1.42/24";
      gateway = "192.168.1.254";
    };
  };
  programs.winbox.enable = true;
  environment.systemPackages = with pkgs; [bottles wireguard-ui reaper];
}
