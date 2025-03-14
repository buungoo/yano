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
			rebuild-switch = "nixos-rebuild switch --flake --use-remote-sudo";
			rebuild-boot = "sudo nixos-rebuild boot --flake --use-remote-sudo";
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
