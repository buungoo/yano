{
  # NOTE:
  # sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
  description = "NixOS Configuration with Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;

      vars = import ./vars.nix;

      mkNixOSConfig = path:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs vars; };
          modules = [ path ];
        };
    in
    {
      nixosConfigurations = {
        dev = mkNixOSConfig ./hosts/dev;
        nas0 = mkNixOSConfig ./hosts/nas0;
      };
    };
}
