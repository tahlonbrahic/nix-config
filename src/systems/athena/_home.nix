{
  lib,
  pkgs,
  ...
}:
{
  home-manager = {
    backupFileExtension = lib.mkForce "temp";
    users = {
      "tahlon" = {
        services.syncthing = {
          enable = true;
          tray.enable = true;
        };
        home.packages = with pkgs; [
          prismlauncher
          limo
          blueman
        ];
        frostbite = {
          browser = {
            librewolf.enable = true;
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
          security.keepassxc.enable = true;
        };
      };
    };
  };
}
