{lib, ...}: {
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        programs.broot.enable = lib.mkForce false;
        #services.gammastep = {
        #  longitude = -85.00;
        #  latitude = 40.00;
        #  provider = "manual";
        #};
        frostbite = {
          #arduino.enable = true;
          browser.firefox.enable = true;

          shells.bash.enable = false;
          programs = {
            git = {
              enable = true;
              userName = "Tahlon Brahic";
              userEmail = "tahlonbrahic@proton.me";
            };
            gpg.enable = false;
          };
          display.hyprland = {
            enable = true;
          };
          security.keepassxc.enable = true;
        };
      };
    };
  };
}
