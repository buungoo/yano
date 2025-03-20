{ config, pkgs, ... }:

{
	imports = [ ./hardware-configuration.nix ]; # Hardware-specific config

	system.stateVersion = "25.05";

	# Machine-specific settings (hostname, bootloader, etc.)
	networking = {
		hostName = "nas0";
		networkmanager.enable = true;
	};
	boot.loader.systemd-boot.enable = true;

	boot.kernelModules = [ "r8169" ];

	# Include common configuration in hosts/common.nix
	# (e.g., timezone, locale, shared packages)
}
