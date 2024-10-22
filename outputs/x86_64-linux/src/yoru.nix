{
  inputs,
  lib,
  customLib,
  vars,
  system,
  ...
} @ customArgs: let
  inherit (inputs) disko sops-nix chaotic nur;
  inherit (customLib) modulesRoot systemTemplate;

  nixModules = with modulesRoot.nixos.opt; [
    fhs
    greetd
    laptop
  ];

  homeModules = with modulesRoot.home.opt; [
    encryption
    fetch
    fish
    fzf
    gpg
    hyprland
    kdeconnect
    kitty
    librewolf
    nvchad
    nix-index
    password
    rofi
    starship
    style
    waybar
    zellij
    zoxide
  ];

  customModules = {
    nixos =
      [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        chaotic.nixosModules.default
        nur.nixosModules.nur
      ]
      ++ nixModules;
    home = [
      ]
      ++ homeModules;
  };

  customVars = vars.users.tahlon // vars.hardware.yoru;
in {
  nixosConfigurations = {
    "yoru" = systemTemplate {
      inherit customArgs customModules customVars;
    };
  };
}
