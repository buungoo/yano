{ config, pkgs, ... }:

let
	# Make sure the bound hostPath is also created
	immichMedia = config.containers.immich2.bindMounts."/var/lib/immich".hostPath;
in
{
	# --- Immich Container Configuration ---
	containers.immich2 = {
		autoStart = true;
		privateNetwork = true;
		hostAddress = "192.168.1.192";
		localAddress = "192.168.1.8";
		bindMounts = {
			"/var/lib/immich" = {
				hostPath = "/storage/immich3";  # Host directory to mount
				isReadOnly = false;
			};
		};
		config = {
			networking.firewall.allowedTCPPorts = [ 2283 ];

			# Immich service configuration inside the container.
			services.immich = {
				enable = true;
				database.enable = true;
				# database.port = 5433;
				host = "0.0.0.0";
				mediaLocation = "/var/lib/immich";  # Container's media directory
			};
			# # Instead of fileSystems, use boot.extraMounts in container config.
			# boot.extraMounts = [
			# 	{
			# 		device = "/storage/immich3";  # Host directory
			# 		target = "/var/lib/immich";     # Mount point in the container
			# 		fsType = "none";
			# 		options = "bind";
			# 	}
			# ];
		};
	};

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
