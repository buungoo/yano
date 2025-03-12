{ config, pkgs, ... }:

{
	# Shared across all machines
	time.timeZone = "Europe/Stockholm";
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "sv_SE.UTF-8";
			LC_IDENTIFICATION = "sv_SE.UTF-8";
			LC_MEASUREMENT = "sv_SE.UTF-8";
			LC_MONETARY = "sv_SE.UTF-8";
			LC_NAME = "sv_SE.UTF-8";
			LC_NUMERIC = "sv_SE.UTF-8";
			LC_PAPER = "sv_SE.UTF-8";
			LC_TELEPHONE = "sv_SE.UTF-8";
			LC_TIME = "sv_SE.UTF-8";
		};
	};
	console.keyMap = "sv-latin1";
	services.xserver.xkb = {
		layout = "se";
		variant = "nodeadkeys";
	};
	environment.systemPackages = with pkgs; [ nvim git ];

	users.users.bungo = {
		isNormalUser = true;
		home = lib.mkDefault "/home/bungo";  # Align with Home Manager
		description = "Main User";
		extraGroups = [ "wheel" "networkmanager" ];
	};

	# Common services (SSH, etc.)
	services.openssh.enable = true;
}
