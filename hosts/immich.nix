{ config, pkgs, ... }:

{
  # Host bridge configuration
  networking.bridges = {
    br0.interfaces = [ "eth0" ]; # Replace 'eth0' with your physical interface
  };
  networking.interfaces = {
    eth0.useDHCP = false; # Disable DHCP on physical interface
    br0.useDHCP = true; # Enable DHCP on bridge (or set static IP)
  };

  containers.immich = {
    autoStart = true;

    privateNetwork = false; # Disable private network
    interfaces = [ "eth0" ]; # Container's network interface

    bindMounts = {
      "/var/lib/immich" = {
        hostPath = "/storage/immich"; # Host directory to mount
        isReadOnly = false;
      };
    };

    config = let immichMedia = "/var/lib/immich"; in
      {
        networking.interfaces.eth0.useDHCP = true; # Or set static IP here
        networking.firewall.allowedTCPPorts = [ 2283 ];

        services.immich = {
          enable = true;
          database.enable = true;
          host = "0.0.0.0";
          mediaLocation = "/var/lib/immich";
        };

        systemd.tmpfiles.rules = [
          "d ${builtins.dirOf immichMedia} 0755 root root -"
          "d ${immichMedia} 0755 immich immich -"
          "d ${immichMedia}/encoded-video 0755 immich immich -"
          "d ${immichMedia}/thumbs 0755 immich immich -"
          "d ${immichMedia}/upload 0755 immich immich -"
          "d ${immichMedia}/library 0755 immich immich -"
          "d ${immichMedia}/profile 0755 immich immich -"
          "d ${immichMedia}/backups 0755 immich immich -"
        ];

        # Oneshot service using the same mediaLocation
        systemd.services.immich-init =
          let
            script = pkgs.writeShellScript "immich-init" ''
              					set -euo pipefail
              					for dir in encoded-video thumbs upload library profile backups; do
              					marker="${immichMedia}/$dir/.immich"
              					if [[ ! -f "$marker" ]]; then
              					touch "$marker"
              					chown immich:immich "$marker"
              					fi
              					done
              					'';
          in
          {
            description = "Immich Initialization (One-Time Setup)";
            wantedBy = [ "immich-server.service" ];
            before = [ "immich-server.service" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${script}";
              User = "root";
            };
          };
      };
  };

  systemd.tmpfiles.rules = [
    "d /storage/immich 0755 root root -"
  ];
}
