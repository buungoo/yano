{ pkgs, ... }:

{
	# Shared home-manager configuration for all users
	home = {
		# Generic packages useful for all users
		packages = with pkgs; [
			neofetch
			fastfetch
			git
			zoxide
		];

		# Shell aliases shared across users
		shellAliases = {
			ll = "ls -l";
			update = "nix flake update";
			rebuild-switch = "sudo nixos-rebuild switch --flake .";
			rebuild-boot = "sudo nixos-rebuild boot --flake .";
		};
	};

	# Common editor configuration (e.g., VSCode or Neovim)
	# programs.vscode = {
	# 	enable = true;
	# 	extensions = with pkgs.vscode-extensions; [
	# 		ms-python.python
	# 		eamodio.gitlens
	# 	];
	# };

	# Shared git configuration
	programs = {
		# Configure zsh for user (you must specify the users shell as zsh first)
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
			userName = "bungo";
			userEmail = "bergdahlalex@protonmail.com";
			extraConfig = {
				init.defaultBranch = "main";
			};
		};
	};
}
