{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gitit;
in
{
  options.services.gitit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Wiki using happstack, git or darcs, and pandoc";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address on which the web server will listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9080;
      description = "Port on which the web server will run.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = '''';
      description = "Content of the configuration file";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/gitit";
      description = "Specifies the path of the repository directory. If it does not exist, Gollum will create it on startup.";
    };

    package = lib.mkPackageOption pkgs "gitit" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "gitit";
      description = "Specifies the owner of the wiki directory";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "gitit";
      description = "Specifies the owner group of the wiki directory";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.gitit = lib.mkIf (cfg.user == "gitit") {
      group = cfg.group;
      description = "Gitit user";
      createHome = false;
      isSystemUser = true;
    };

    users.groups."${cfg.group}" = { };

    systemd.tmpfiles.rules = [ "d '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -" ];

    systemd.services.gitit = {
      description = "Wiki using happstack, git or darcs, and pandoc";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.git ];

      preStart = ''
               # This is safe to be run on an existing repo
        pwd
               #cd ${cfg.stateDir}
               #gitit
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = ''
          ${cfg.package}/bin/gitit \
            --port=${toString cfg.port} \
            --listen=${cfg.address} \
            # --config-file=${pkgs.writeText "gitit-config.rb" cfg.extraConfig} \
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    tahlonbrahic
  ];
}
