{ inputs, outputs, vars, ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix

    ../immich.nix
  ];
}
