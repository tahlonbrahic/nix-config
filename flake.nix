{
  description = "NixOS configuration that follows fuyu-no-kosei.";

  outputs = inputs @ {
    flake-utils,
    nixpkgs,
    kosei,
    ...
  }: let
    inherit (inputs.nixpkgs) lib;
    outPath = ./.;
  in
    flake-utils.lib.eachDefaultSystemPassThrough (system: let
      basePkgs =
        import nixpkgs
        {
          inherit system;
          config.allowUnfree = true;
        };
      pkgs = basePkgs.appendOverlays [inputs.fuyuvim.overlays.default inputs.nur.overlays.default];
    in {
      nixosConfigurations = kosei.lib.loadConfigurations "scoped" {
        inherit inputs lib pkgs outPath;
        src = ./src/systems;
      };
    });

  inputs = {
    assets = {
      url = "github:TahlonBrahic/assets";
      flake = false;
    };
    kosei = {
      url = "github:TahlonBrahic/fuyu-no-kosei";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fuyu-no-nur = {
      url = "github:TahlonBrahic/fuyu-no-nur";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    fuyuvim = {
      url = "github:TahlonBrahic/fuyu-no-neovim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        fuyu-no-nur.follows = "fuyu-no-nur";
      };
    };
    eris = {
      url = "github:TahlonBrahic/eris";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    jeezyvim = {
      url = "github:LGUG2Z/JeezyVim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
