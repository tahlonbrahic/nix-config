{
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        frostbite = {
          programs = {
            git = {
              enable = false;
              userName = "Tahlon Brahic";
              userEmail = "tahlonbrahic@proton.me";
            };
            gpg.enable = false;
          };
        };
      };

      "amy" = {
        stylix.targets.hyprpaper.enable = lib.mkForce false;
        programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];
        frostbite = {
          browser = {
            firefox.enable = true;
            chrome.enable = true;
          };
          programs = {
            git = {
              enable = true;
              userName = "Tahlon Brahic";
              userEmail = "tahlonbrahic@proton.me";
            };
            gpg.enable = false;
            obs-studio.enable = true;
            #vesktop.enable = true;
          };
          display.hyprland = {
            enable = false;
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
