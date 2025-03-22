{ config, pkgs, inputs, outputs, vars, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = vars.stateVersion;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;

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

  networking = {
    hostName = vars.hostName;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  # Install for all users
  programs = {
    zsh.enable = true;
  };

  users.users.${vars.userName} = {
    isNormalUser = true;
    home = "/home/${vars.userName}"; # Align with Home Manager
    description = vars.userName;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh; # Set shell (defaults to bash otherwise)
  };

  home-manager =
    {
      extraSpecialArgs = { inherit inputs outputs vars; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${vars.userName} = import ../home/${vars.userName}.nix;
    };

  services.openssh.enable = true;
}
