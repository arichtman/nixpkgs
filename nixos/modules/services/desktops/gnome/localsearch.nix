# LocalSearch daemons.

{ config, pkgs, lib, ... }:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.localsearch = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable LocalSearch, indexing services for TinySPARQL
          search engine and metadata storage system.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.gnome.localsearch.enable {

    environment.systemPackages = [ pkgs.tracker-miners ];

    services.dbus.packages = [ pkgs.tracker-miners ];

    systemd.packages = [ pkgs.tracker-miners ];

  };

}
