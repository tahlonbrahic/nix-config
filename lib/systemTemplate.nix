{
  inputs,
  system,
  lib,
  pkgs,
  localLib,
  vars,
  overlays,
  modules,
  users,
  hostName
}: let
  inherit (inputs) home-manager nur chaotic;
  inherit (localLib) baseNixosModules baseHomeModules;
  specialArgs = extraSpecialArgs // {inherit lib;};
  extraSpecialArgs = {inherit inputs system pkgs localLib vars overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      baseNixosModules
      ++ [ nur.nixosModules.nur ]
      ++ [ chaotic.nixosModules.default ]
      ++ modules.nixos
      ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            inherit extraSpecialArgs;
            backupFileExtension = "backup_delete";
            sharedModules = baseHomeModules;
            users = lib.attrsets.genAttrs users (user: { imports = modules.homeManager; });
          };
        }
      ];
  }

