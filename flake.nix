{
  description = "A simple NixOS flake config";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-25.05 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-ld.url = "github:nix-community/nix-ld";
    # this line assume that you also have nixpkgs as an input
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      nixos-hardware,
      nix-ld,
      ...
    }@inputs:
    {
      # 请将下面的 my-nixos 替换成你的 hostname
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # 这里导入之前我们使用的 configuration.nix，
          # 这样旧的配置文件仍然能生效
          # ./configuration.nix
          ./common/packages.nix
          ./common/env.nix
          ./common/neovim.nix
          # nixos-wsl.nixosModules.default
          # {
          #   system.stateVersion = "25.05";
          #   wsl.enable = true;
          # }

        ];
      };
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./wsl/init.nix
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
          }
        ];
      };
    };
}
