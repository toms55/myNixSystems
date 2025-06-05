{
  description = "Tom's NixOS + macOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            ./nixos/hardware-configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        Toms-MacBook-Pro = darwin.lib.darwinSystem {
          system = "aarch64-darwin"; 
          modules = [
            ./darwin/configuration.nix
          ];
        };
      };
    };
}


