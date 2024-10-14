{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    which
    tree
    rsync
    sysstat
    iotop
    iftop
    btop
    nmon
    sysbench
    pciutils
    usbutils
    lm_sensors
    psmisc
    dmidecode
    parted
    ethtool
    just
    neofetch
    vim
    age
    gnupg
    direnv
    broot
    tmux
    curl
    htop
    killall
    findutils
    ripgrep
    bottom
    du-dust
    findutils
    fd
    fx
    sd
    procs
  ];

  environment.variables.EDITOR = "vim";
}
