{pkgs, ...}: {
  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = true;
    #resolvconf.enable = false;
    #useHostResolvConf = false;
    #tempAddresses = "disabled";
    enableIPv6 = false;
    dhcpcd.enable = false;
    wireless = {
      #enable = true;
      iwd.enable = true;
    };
  };

  environment.systemPackages = [pkgs.iwgtk];

  # systemd.network = {
  #  enable = true;
  #
  #  networks = {
  #    "10-wireless" = {
  #      matchConfig.Name = "wlo1";
  #      networkConfig.DHCP = "yes";
  #    };
  #  };
  #};
}
