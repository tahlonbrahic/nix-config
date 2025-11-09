{
  lib,
  pkgs,
  ...
}: {
  hardware.ckb-next.enable = true;
  services = {
    openssh.enable = lib.mkForce true;
    openssh.passwordAuthentication = lib.mkForce true;
    xserver.enable = true;
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager.gdm.wayland = false;
    gnome.gnome-keyring.enable = true;
    #greetd.settings.default_session.command = '''';
  };
  security.pam.services.display-manager.enableGnomeKeyring = true;
  services.greetd.enable = lib.mkForce false;
  environment.systemPackages = with pkgs; [hydrapaper];
}
