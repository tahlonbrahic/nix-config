{inputs}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (lib) genAttrs attrsets;

  supportedSystems = ["x86_64-linux" "aarch64-linux"];

  forAllSystems = genAttrs supportedSystems;

  arguments = forAllSystems (system: {
    inherit inputs system lib;
    inherit (pkgs.${system}) pkgs;
    inherit (localLib.${system}) localLib;
    inherit (localLib.${system}.localLib) vars;
  });

  systems = forAllSystems (system: import ./${system} (arguments.${system}));

  systemValues = builtins.attrValues systems;

  #DEBUG
  #systemValues = lib.debug.traceSeqN 1 (builtins.attrValues systems)[1] {};
  #systemValues = builtins.trace arguments.x86_64-linux.inputs (builtins.attrValues systems);
  #systemValues = builtins.trace  (builtins.attrValues systems);
  #systemValues = lib.debug.traceSeqN 2 (builtins.elemAt (builtins.attrValues systems) 1) (builtins.attrValues systems);

  localLib = forAllSystems (system:
    import ../lib {
      inherit inputs system;
      pkgs = pkgs.${system};
    });

  pkgs = forAllSystems (system: import nixpkgs {inherit system;});

  ### FLAKE OUTPUTS ###

  formatter = forAllSystems (system: pkgs.${system}.alejandra);

  devShells = forAllSystems (system: import ../shell.nix (pkgs.${system}));

  nixosConfigurations = attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) systemValues);

  nixOnDroidConfigurations = attrsets.mergeAttrsList (map (it: it.nixOnDroidConfigurations or {}) systemValues);
in {inherit formatter devShells nixosConfigurations nixOnDroidConfigurations;}
