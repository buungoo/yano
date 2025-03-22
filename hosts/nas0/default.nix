{ inputs, outputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
    ../common.nix
  ];

  system.stateVersion = "24.11";

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
