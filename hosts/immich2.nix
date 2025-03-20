{ config, pkgs, ... }:

{
	networking = {
		# Create a bridge "br0" using your wireless interface.
		bridges.br0.interfaces = [ "wlp2s0" ];

		# Let the bridge obtain its IP via DHCP.
		useDHCP = false;
		interfaces."br0".useDHCP = true;
	};

	# --- Immich Container Configuration ---
	containers.immich = { config, pkgs, ... }: {
		config = {
			networking.useDHCP = true;

			virtualisation.container.privateNetwork = true;
			virtualisation.container.hostBridge = "br0";

			# Immich service configuration inside the container.
			services.immich = {
				enable = true;
				port = 2283;
				host = "0.0.0.0";
				mediaLocation = "/var/lib/immich";  # Container's media directory
			};

			# Instead of fileSystems, use boot.extraMounts in container config.
			boot.extraMounts = [
				{
					device = "/storage/immich3";  # Host directory
					target = "/var/lib/immich";     # Mount point in the container
					fsType = "none";
					options = "bind";
				}
			];
		};
	};

	# (Optional) Host firewall rule to allow the container's exposed port.
	networking.firewall.allowedTCPPorts = [ 2283 ];
}
