{
  lib,
  pkgs,
  ...
}: {
  frostbite.networks.wireless = {
    enable = true;
    additionalWhistelistedInterfaces = ["wlp7s0"];
    pci = "pci-0000:00:14.3*";
  };
  programs.winbox.enable = true;
  environment.systemPackages = with pkgs; [bottles wireguard-ui reaper];
}
