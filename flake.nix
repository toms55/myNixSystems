{
  description = "nixOS and macOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-26.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          { _module.args = { inherit inputs; hasBluetooth = false; }; }
        ];
      };
      nixos-ssd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration-ssd.nix
          home-manager.nixosModules.home-manager
          { _module.args = { inherit inputs; hasBluetooth = true; }; }
        ];
      };
    };
    darwinConfigurations = {
      Toms-MacBook-Pro = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tom = import ./home.nix;
            home-manager.extraSpecialArgs = { hasBluetooth = false; };
          }
        ];
      };
    };
    
    homeConfigurations = {
      "tom@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { hasBluetooth = false; };
        modules = [ ./home.nix ];
      };
   };
  };
}
