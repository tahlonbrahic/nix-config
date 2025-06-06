{
  description = "NixOS configuration that follows fuyu-no-frostbite.";
  outputs = inputs @ {
    flake-parts,
    frostbite,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;}
    ({self, ...}: {
      debug = true;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        flake-parts.flakeModules.modules
        flake-parts.flakeModules.partitions
      ];

      partitions = {
        dev = {
          module = ./src/dev;
          extraInputsFlake = ./src/dev;
        };
      };

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
        herculesCI = "dev";
      };

      perSystem = {system, ...}: {
        formatter = inputs.frostbite.inputs.nixpkgs.legacyPackages.${system}.alejandra;
      };

      flake = {
        nixosConfigurations = frostbite.lib.loadConfigurations "scoped" {
          inherit (self) outPath;
          inputs = self.inputs // self.inputs.frostbite.inputs;
          src = ./src/systems;
        };
      };
    });

  inputs = {
    frostbite.url = "github:cryomancy/frostbite";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
}
