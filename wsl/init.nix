{config, pkgs, lib,...}:
{
	imports = [
		../common/neovim.nix
		../common/packages.nix
		../common/env.nix
	];
}
