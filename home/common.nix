{ pkgs, ... }:

{
	# Shared home-manager configuration for all users
	home = {
		# Generic packages useful for all users
		packages = with pkgs; [
			fastfetch
			git
			zoxide
		];

		# Shell aliases shared across users
		shellAliases = {
			ll = "ls -l";
			update = "nix flake update";
			rebuild-switch = "sudo nixos-rebuild switch --flake";
			rebuild-boot = "sudo nixos-rebuild boot --flake";
		};
	};

	# Shared git configuration
	programs = {
		# Configure zsh for users (you must specify the users shell as zsh first)
		zsh = {
			enable = true;
			enableCompletion = true;
			autosuggestion.enable = true;
			syntaxHighlighting.enable = true;
		};
		zoxide = {
			enable = true;
			options = [ "--cmd cd" ];
		};
		git = {
			enable = true;
			extraConfig = {
				init.defaultBranch = "main";
			};
		};
	};
}
