{
  inputs,
  username,
  pkgs,
  ...
}:
{
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
	"${username}"
    "butter"
    "root"
  ];

  environment.variables = {
    IS_NIXOS = "true";
  };
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  time.timeZone = "Asia/Shanghai";
}
