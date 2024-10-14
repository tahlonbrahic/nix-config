{
  inputs,
  customLib,
  vars,
  ...
} @ args: let
  inherit (inputs) disko sops-nix stylix;
  inherit (customLib) modulesRoot systemTemplate;

  nixModules = with modulesRoot.nixos.opt; [
    greetd
    fhs
  ];

  homeModules = with modulesRoot.home.opt; [
    sway
    kitty
    encryption
    gpg
    password
    zellij
  ];

  modules = {
    nixos =
      [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
      ]
      ++ nixModules;
    home = homeModules;
  };

  outputVars = vars.users.tahlon // vars.hardware.athena;
in {
  nixosConfigurations = {
    "athena" = systemTemplate {
      inherit args modules;
      vars = outputVars;
    };
  };
}
