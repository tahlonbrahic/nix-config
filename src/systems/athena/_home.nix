{lib, ...}: {
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        wayland.windowManager.hyprland.extraConfig = ''
          general {
              col.active_border = rgba(F7DCDE39)
              col.inactive_border = rgba(A58A8D30)
          }
        '';
        stylix.targets.hyprpaper.enable = lib.mkForce false;
        frostbite = {
          browser = {
            firefox.enable = true;
          };
          programs = {
            git = {
              enable = true;
              userName = "Tahlon Brahic";
              userEmail = "tahlonbrahic@proton.me";
            };
            gpg.enable = false;
            obs-studio.enable = true;
          };
          display.hyprland = {
            enable = true;
            hypridle.enable = false;
          };
          security.keepassxc.enable = true;
        };
      };
    };
  };
}
