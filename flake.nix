{
# NOTE:
# sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
	description = "NixOS Configuration with Flakes";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs: {
		nixosConfigurations = {
			# Build with: sudo nixos-rebuild switch --flake .#nas0
			nas0 = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/nas0/default.nix
					./hosts/common.nix
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.bungo = import ./home/bungo.nix;
					}
				];
			};
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
