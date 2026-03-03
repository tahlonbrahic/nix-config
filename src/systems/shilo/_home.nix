{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home-manager = {
    users = {
      "tahlon" = {
        programs = {
          freetube.enable = true;
          lapce.enable = true;
          sioyek.enable = true;

          script-directory = {
            enable = true;
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

        home.packages = [ pkgs.nwg-displays ];

        #systemd.user.services.ashell = {
        #  Unit = {
        #    Description = "ashell status bar";
        #    Documentation = "https://github.com/MalpenZibo/ashell/tree/0.4.1";
        #    After = ["hyprland-session.target"];
        #  };

        #  Service = {
        #    ExecStart = "${lib.getExe pkgs.ashell}";
        #    Restart = "on-failure";
        #  };

        #  Install.WantedBy = ["hyprland-session.target"];
        #};
       
        frostbite = {
          browser = {
            librewolf.enable = true;
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
          utils.cli.enable = false;

          security.keepassxc.enable = true;
        };
      };
    };
  };
}
