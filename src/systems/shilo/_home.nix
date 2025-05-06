{lib, ...}: {
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
                stylix.targets.hyprpaper.enable = lib.mkForce false;
        frostbite = {
browser = {
            firefox.enable = true;
            chrome.enable = true;
          };
          programs = {
            git = {
              enable = false;
              userName = "Tahlon Brahic";
              userEmail = "tbrahic@selecttechservices.com";
            };
            gpg.enable = false;
          };
  display.hyprland = {
            enable = true;
            displays.config = ''
              monitor = DP-1, 2560x1080, 1920x0, 1
              monitor = HDMI-A-1, 1920x1080, 0x0, 1, transform, 3
            '';
          };

                  security.keepassxc.enable = true;
        };
      };

         };
  };
}
