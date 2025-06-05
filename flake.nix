{
  description = "nixOS and macOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.tom = { pkgs, ... }: {
              home.username = "tom";
              home.homeDirectory = "/home/tom";
              home.stateVersion = "23.11";
              programs.alacritty.enable = true;
              xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty.toml;
            };
          }
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
            home-manager.useUserPackages = true;
            home-manager.users.tom = { pkgs, ... }: {
              home.username = "tom";
              home.homeDirectory = "/Users/tom";
              home.stateVersion = "23.11";
              programs.alacritty.enable = true;
              xdg.configFile."alacritty/alacritty.toml".source = ./config/alacritty.toml;
            };
          }
        ];
      };
    };
  };
}



