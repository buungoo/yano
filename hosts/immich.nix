{ config, pkgs, ... }:

let
	# Reference the mediaLocation from the Immich config
	immichMedia = config.services.immich.mediaLocation;
in {
	services.immich = {
		enable = true;
		port = 2283;
		host = "0.0.0.0";
		mediaLocation = "/storage/immich2";  # Single source of truth
	};

	# Dynamically create parent directory
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
	systemd.services.immich-init = let
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
	in {
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
}
