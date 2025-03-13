{ lib, pkgs, ... }:

{
	imports = [ ./common.nix ];  # Inherit shared settings

	# User-specific additions/overrides
	home = {
		username = "bungo";
		homeDirectory = "/home/bungo";
		stateVersion = "25.05";

		# Additional packages just for this user
		packages = with pkgs; [
			btop
		];

		# Additional shell aliases
		shellAliases = {
			gs = "git status";
		};
	};

	programs = {
		git = {
			userEmail = lib.mkForce "bergdahlalex@protonmail.com";
			userName = lib.mkForce "bungo";
		};
	};
}
