{inputs, ...}: {
  systems = ["x86_64-linux"];

  imports = [
    inputs.devshell.flakeModule
    inputs.hercules-ci-effects.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "Frostbite Development Shell";
      devshell.prj_root_fallback = {
        # Use the top-level directory of the working tree
        eval = "$(git rev-parse --show-toplevel)";
      };

      motd = ''
        {117}❄ Frostbite Developement Shell ❄{reset}
        $(type -p menu &>/dev/null && menu)
      '';
      env = [
        {
          name = "IN_KOSEI_SHELL";
          value = 0;
        }
        {
          name = "NIX_CONFIG";
          value = "experimental-features = nix-command flakes pipe-operators";
        }
        {
          name = "NIXPKGS_ALLOW_UNFREE";
          value = 1;
        }
      ];
      commands = [
        {
          name = "repl";
          command = ''
            nix repl
          '';
          help = "Enter this flake's REPL";
        }
        {
          name = "rebuild";
          command = ''
            sudo nixos-rebuild switch --max-jobs 2 --cores 2 -vv
          '';
          help = "Rebuild the flake with limited system utilization and verbose logging";
        }
        {
          name = "update";
          command = "nix flake update frostbite";
          help = "Pull upstream flake inputs from Frostbite";
        }
      ];
      packages = [
        pkgs.typos
        pkgs.sops
        pkgs.git
      ];
    };

    pre-commit = {
      settings = {
        addGcRoot = true;
        hooks = {
          alejandra.enable = true;
        };
      };
    };
  };
}
