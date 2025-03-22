{ lib, pkgs, vars, osconfig, ... }:

{
  imports = [ ./common.nix ]; # Inherit shared settings

  # User-specific additions/overrides
  home = {
    username = vars.userName;
    homeDirectory = lib.mkMerge [ "/home/${vars.userName}" ];
    stateVersion = vars.stateVersion;

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
      userEmail = lib.mkForce vars.userEmail;
      userName = lib.mkForce vars.userName;
    };
  };
}
