{ config, pkgs, ... }:

{
	imports = [ ./hardware-configuration.nix ]; # Hardware-specific config

	system.stateVersion = "24.11";

	# Machine-specific settings (hostname, bootloader, etc.)
	networking = {
		hostName = "nas0";
		networkmanager.enable = true;
	};
	boot.loader.systemd-boot.enable = true;

	# Include common configuration in hosts/common.nix
	# (e.g., timezone, locale, shared packages)
}
