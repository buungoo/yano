{ inputs, outputs, vars, ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix

  ];

  boot.kernelModules = [ "r8169" ]; # Ethernet module
}
