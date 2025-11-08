{lib, ...}: {
  hardware.ckb-next.enable = true;
  services = {
    openssh.enable = lib.mkForce true;
    openssh.passwordAuthentication = lib.mkForce true;
    xserver.enable = true;
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;
  };
}
