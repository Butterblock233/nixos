{
  description = "A simple NixOS flake config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    nix-ld = {
      url = "github:nix-community/nix-ld";
      # this line assume that you also have nixpkgs as an input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dotfiles = {
    #   url = "github:Himalian/dotfiles";
    #   flake = false;
    # };
    # github:[username]/[reponame]/[branchname]
    # helix.url = "github:helix-editor/helix/master";
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    # extra-trusted-public-keys = [
    # ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-wsl,
      nixos-hardware,
      nix-ld,
      home-manager,
      agenix,
      # dotfiles,
      ...
    }@inputs:
    let
      username = "himalian";
    in
    {
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          # WSL distro
          system = "x86_64-linux";
          specialArgs =
            let
              system = "x86_64-linux";
            in
            {
              inherit inputs username;
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              pkgs-stable = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            };
          modules = [
            ./wsl/init.nix
            nixos-wsl.nixosModules.default
            {
              # Do not edit this stateVersion.
              # stateVersion defines the initial state of the system.
              # Make an annology, You created a Minecraft save at 1.16.5, then you can upgrade to 1.17, 1.18, ...
              # but the initial version is still 1.16.5, if you change it, it may break the initial data staucture and cause some problems
              # so pin this stateVersion to keep system in stable.
              # do you read the comment?
              system.stateVersion = "25.05";
              wsl.enable = true;
              wsl.defaultUser = "${username}";
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} = import ./wsl/home.nix;

              # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
              home-manager.extraSpecialArgs = {
                inherit inputs username;
                pkgs-unstable = import inputs.nixpkgs-unstable {
                  system = "x86_64-linux"; # 或者使用 lib.system
                  config.allowUnfree = true;
                };
              };

            }

          ];
        };
        # configuration for remote machines
        remote = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs username; };
          modules = [ ];

        };
      };
    };
}
