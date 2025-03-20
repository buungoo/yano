{ config, pkgs, ... }:

let
	# Make sure the bound hostPath is also created
	immich2Media = config.containers.immich2.bindMounts."/var/lib/immich".hostPath;
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

	# Oneshot service to create markers - runs on HOST before container starts
	systemd.services.immich2-init = let
		script = pkgs.writeShellScript "immich2-init" ''
		set -euo pipefail
		for dir in encoded-video thumbs upload library profile backups; do
		marker="${immich2Media}/$dir/.immich"
		if [[ ! -f "$marker" ]]; then
		touch "$marker"
		chown immich:immich "$marker"
		fi
		done
		'';
	in {
		description = "Immich Host Initialization";
		# Target the container service directly
		wantedBy = [ "container@immich2.service" ];
		before = [ "container@immich2.service" ];
		serviceConfig = {
			Type = "oneshot";
			RemainAfterExit = true;
			ExecStart = "${script}";
			User = "root";
		};
	};
}
