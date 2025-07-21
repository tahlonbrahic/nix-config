{lib, ...}: {
  hardware.ckb-next.enable = true;
  services.openssh.enable = lib.mkForce true;
  services.openssh.passwordAuthentication = lib.mkForce true;
}
