{ config, pkgs, ... }:

{
	networking = {
		# Create a bridge "br0" and add your wireless interface to it.
		bridges.br0.interfaces = [ "wlp2s0" ];

		# Do not use DHCP for the host overall; instead, let the bridge handle DHCP.
		useDHCP = false;

		# Configure br0 to obtain its IP address via DHCP.
		interfaces."br0".useDHCP = true;
	};

	# --- Immich Container Configuration ---
	containers.immich = { config, pkgs, ... }: {
		# Omit localAddress so the container gets its IP from DHCP.
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

			# Bind-mount the host's /storage/immich3 directory into the container.
			fileSystems."/var/lib/immich" = {
				device = "/storage/immich3";  # Host directory
				fsType = "none";
				options = "bind";
			};
		};
	};

	# (Optional) Host firewall rule to allow the container's exposed port.
	networking.firewall.allowedTCPPorts = [ 2283 ];
}
