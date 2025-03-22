{ inputs, outputs, vars, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
    ../common.nix
  ];

  system.stateVersion = vars.stateVersion;

  networking = {
    hostName = "nas0";
    networkmanager.enable = true;
  };
  boot.loader.systemd-boot.enable = true;

  home-manager =
    {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.bungo = import ../../home/bungo.nix;
    };
}
