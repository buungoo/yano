{ config, pkgs, ... }:

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
}
