{ config, pkgs, ... }:

{
	# --- Immich Container Configuration ---
	containers.immich2 = {
		autoStart = true;
		config = {
			# Immich service configuration inside the container.
			services.immich = {
				enable = true;
				port = 2284;
				database.enable = true;
				# host = "0.0.0.0";
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

	# (Optional) Host firewall rule to allow the container's exposed port.
	# networking.firewall.allowedTCPPorts = [ 2283 ];
}
