{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  home-manager = {
    #backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        stylix.targets.hyprpaper.enable = lib.mkForce false;
        programs = {
          freetube.enable = true;
          #git.riff.enable = true;
          lapce.enable = true;
          script-directory.enable = true;
          sioyek.enable = true;
          wayprompt.enable = true;
          wlogout.enable = true;

          zellij = {
            attachExistingSession = true;
            enableFishIntegration = lib.mkDefault true;
            exitShellOnExit = true;
          };
        };

        services = {
          #hyprpolkit.enable = true;
          #shikane
          kanshi.enable = true;
          #linux-wallpaperengine = {
          #  enable = true;
          #  assetsPath = "${inputs.frostbite.inputs.assets.outPath}";
          #};
        };

        home.packages = [pkgs.ashell];

        systemd.user.services.ashell = {
          Unit = {
            Description = "ashell status bar";
            Documentation = "https://github.com/MalpenZibo/ashell/tree/0.4.1";
            After = ["hyprland-session.target"];
          };

          Service = {
            ExecStart = "${lib.getExe pkgs.ashell}";
            Restart = "on-failure";
          };

          Install.WantedBy = ["hyprland-session.target"];
        };
        frostbite = {
          browser = {
            firefox.enable = true;
            chrome.enable = true;
          };
          programs = {
            git = {
              enable = true;
              userName = "Tahlon Brahic";
              userEmail = "tbrahic@selecttechservices.com";
            };
            gpg.enable = false;
            obsidian.enable = true;
            vesktop.enable = false;
          };

          display.hyprland = {
            enable = true;
            waybar.enable = false;
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
