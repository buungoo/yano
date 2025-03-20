{ config, pkgs, ... }:

{
	# --- Immich Container Configuration ---
	containers.immich2 = {
		autoStart = true;
		privateNetwork = true;
		hostAddress = "192.168.1.192";
		localAddress = "192.168.1.8";
		config = {
			# services.postgresql = {
			# 	enable = true;
			# 	settings = {
			# 		port = 5433;  # Change the PostgreSQL port inside the container
			# 		# listen_addresses = "127.0.0.1";  # Restrict to localhost inside the container
			# 	};
			# };

			# Immich service configuration inside the container.
			services.immich = {
				enable = true;
				port = 2284;
				database.enable = true;
				database.port = 5433;
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
