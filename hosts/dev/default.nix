{ inputs, outputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
    ../common.nix
  ]; # Hardware-specific config

  system.stateVersion = "25.05";

  # Machine-specific settings (hostname, bootloader, etc.)
  networking = {
    hostName = "dev";
    networkmanager.enable = true;
  };
  boot.loader.systemd-boot.enable = true;
  boot.kernelModules = [ "r8169" ];

  home-manager =
    {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.bungo = import ../../home/bungo.nix;
    };

  # Include common configuration in hosts/common.nix
  # (e.g., timezone, locale, shared packages)
}
