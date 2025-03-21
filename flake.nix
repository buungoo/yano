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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      mkNixOSConfig = path:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ path ];
        };
    in
    {
      nixosConfigurations = {
        dev = mkNixOSConfig ./hosts/dev;
        # Build with: sudo nixos-rebuild switch --flake .#nas0
        # dev = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     ./hosts/dev
        #     ./hosts/common.nix
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.useGlobalPkgs = true;
        #       home-manager.useUserPackages = true;
        #       home-manager.users.bungo = import ./home/bungo.nix;
        #     }
        #   ];
        # };
        # machine2 = nixpkgs.lib.nixosSystem {
        # 	system = "x86_64-linux";
        # 	modules = [
        # 		./hosts/machine2/default.nix
        # 		./hosts/common.nix
        # 		home-manager.nixosModules.home-manager
        # 		{
        # 			home-manager.useGlobalPkgs = true;
        # 			home-manager.useUserPackages = true;
        # 			home-manager.users.user1 = import ./home/bungo.nix;
        # 		}
        # 	];
        # };
      };
    };
}
