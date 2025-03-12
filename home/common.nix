{ pkgs, ... }:

{
	# Shared home-manager configuration for all users
	home = {
		# Generic packages useful for all users
		packages = with pkgs; [
			neofetch
			git
			curl
			wget
			jq
		];

		# Shell aliases shared across users
		shellAliases = {
			ll = "ls -l";
			update = "nix flake update";
			rebuild = "sudo nixos-rebuild switch --flake .";
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
