{ config, pkgs, ... }:

{
  # Physical interface – DHCP is enabled on enp1s0.
  networking.interfaces.enp3s0.useDHCP = true; # This is REQUIRED

  # Create a dedicated bridge for containers with a static IP
  networking.bridges.containerBridge = {
    interfaces = [ ]; # No physical interface attached
  };
  networking.interfaces.containerBridge = {
    ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
  };

  # Enable NAT on the host.
  networking.nat = {
    enable = true;
	 # Explicitly specify NAT interfaces
    internalInterfaces = [ "vb-immich" ];
    externalInterface = "enp3s0";
  };

  containers.immich = {
    autoStart = true;

    privateNetwork = true;
    hostBridge = "containerBridge"; # Attach to the container bridge
    localAddress = "10.0.0.2/24"; # Container IP

    forwardPorts = [
      {
        hostPort = 80;
        containerPort = 2283;
      }
    ];

    bindMounts = {
      "/var/lib/immich" = {
        hostPath = "/storage/immich"; # Host directory to mount
        isReadOnly = false;
      };
    };

    config = let immichMedia = "/var/lib/immich"; in
      {
        networking.interfaces.eth0.useDHCP = false; # Or set static IP here
        networking.firewall.allowedTCPPorts = [ 2283 ];
        networking.defaultGateway = "10.0.0.1";

        services.immich = {
          enable = true;
          database.enable = true;
          host = "10.0.0.2";
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
