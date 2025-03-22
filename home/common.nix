{ pkgs, ... }:

{
  # Shared home-manager configuration for all users
  home = {
    stateVersion = vars.stateVersion;

    # Generic packages useful for all users
    packages = with pkgs; [
      fastfetch
      git
      zoxide
    ];

    # Shell aliases shared across users
    shellAliases = {
      update = "nix flake update";
      rebuild-switch = "nixos-rebuild switch --use-remote-sudo --flake";
      rebuild-boot = "nixos-rebuild boot --use-remote-sudo --flake";
    };
  };

  # Shared configuration
  programs = {
    # Configure zsh for users (the users shell must be speicified as zsh before)
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
