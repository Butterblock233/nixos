{
  description = "A simple NixOS flake config";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.05 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    agenix.url = "github:ryantm/agenix";
    nix-ld = {
      url = "github:nix-community/nix-ld";
      # this line assume that you also have nixpkgs as an input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # github:[username]/[reponame]/[branchname]
    # helix.url = "github:helix-editor/helix/master";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
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
      ...
    }@inputs:
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
              inherit inputs;
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
              system.stateVersion = "25.05";
              wsl.enable = true;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.nixos = import ./wsl/home.nix;

              # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
              # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
              home-manager.extraSpecialArgs = {
                # 没看懂这里写了啥，先放这里
                pkgs-unstable = import inputs.nixpkgs-unstable {
                  system = "x86_64-linux"; # 或者使用 lib.system
                  config.allowUnfree = true;
                };
              };

            }

            # # Nix-ld
            #          nix-ld.nixosModules.nix-ld
            #          # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
            #          # to not collide with the nixpkgs version.
            #          { programs.nix-ld.dev.enable = true; }
          ];
        };
        # configuration for remote machines
        remote = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ];

        };
      };
    };
}
