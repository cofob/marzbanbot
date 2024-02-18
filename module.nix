{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.services.marzbanbot;
  marzbanbot = pkgs.callPackage ./package.nix { };
in
{
  options.services.marzbanbot = {
    enable = mkEnableOption "Enable marzban bot";

    envFile = mkOption {
      type = types.path;
      description = "Path to env secrets";
    };

    datadir = mkOption {
      type = types.path;
      default = "/var/lib/marzbanbot";
      description = "Data directory";
    };

    package = mkOption {
      type = types.package;
      default = marzbanbot;
      description = "Marzbanbot package to use";
    };
  };

  config.systemd.services = mkIf cfg.enable {
    marzbanbot = {
      enable = true;
      description = "Marzban telegram bot";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        User = "marzbanbot";
        Group = "marzbanbot";
        WorkingDirectory = cfg.datadir;
        ExecStart = "${cfg.package}/bin/marzbanbot";
        Restart = "on-failure";
        RestartSec = "1s";
        EnvironmentFile = cfg.envFile;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  config.users = mkIf cfg.enable {
    users.marzbanbot = {
      isSystemUser = true;
      description = "Marzbanbot user";
      home = cfg.datadir;
      createHome = true;
      group = "marzbanbot";
    };

    groups.marzbanbot = { };
  };
}
