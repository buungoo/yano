{ config, pkgs, ... }:

{
	imports = [ ./immich.nix ];

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
	environment.systemPackages = with pkgs; [
		neovim
		git
	];

	# Install for all users
	programs = {
		zsh.enable = true;
	};

	users.users.bungo = {
		isNormalUser = true;
		home = "/home/bungo";  # Align with Home Manager
		description = "Main User";
		extraGroups = [ "wheel" "networkmanager" ];
		shell = pkgs.zsh; # Set shell (defaults to bash otherwise)
	};

	# Common services (SSH, etc.)
	services.openssh.enable = true;

	networking.firewall.allowedTCPPorts = [ 2283 ];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
