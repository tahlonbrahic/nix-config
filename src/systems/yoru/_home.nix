{lib, ...}: {
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        stylix.targets.hyprpaper.enable = lib.mkForce false;
        frostbite = {
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
