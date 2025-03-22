{ inputs, outputs, vars, ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix

    ../immich.nix
  ];

  boot.kernelModules = [ "r8169" ]; # Ethernet module
}
