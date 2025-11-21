{ pkgs, ... }:
{
  home-manager = {
    users = {
      "tahlon" = {
        home.packages = with pkgs; [ multivnc ];
        frostbite = {
          browser.firefox.enable = true;
          programs = {
            git = {
              enable = true;
              userName = "Tahlon Brahic";
              userEmail = "tahlonbrahic@proton.me";
            };
            gpg.enable = false;
          };
          security.keepassxc.enable = true;
        };
      };
    };
  };
}
