{
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
  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    IS_NIXOS = "true";
  };

}
