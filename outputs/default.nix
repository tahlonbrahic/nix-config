{ ... }@inputs:

let
  inherit (inputs.nixpkgs) lib;

  bin = import ../bin { inherit lib inputs; };
  vars = import ../vars { inherit lib; };

  args = { inherit inputs lib bin vars; };

  systems = {
    x86_64-linux = import ./x86_64-linux args;
  };

  systemValues = builtins.attrValues systems;

in {
  nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) systemValues);
}
