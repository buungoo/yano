{ inputs, outputs, vars, ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix

    ../immich.nix
  ]; # Hardware-specific config

  system.stateVersion = vars.stateVersion;

  # Machine-specific settings (hostname, bootloader, etc.)
  networking = {
    hostName = vars.hostName;
    networkmanager.enable = true;
  };
  boot.loader.systemd-boot.enable = true;
  boot.kernelModules = [ "r8169" ]; # Ethernet module

  # Include common configuration in hosts/common.nix
  # (e.g., timezone, locale, shared packages)
}
