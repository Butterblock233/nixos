{
  config,
  lib,
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

  # Configure agenix to use ssh-agent for decryption
  age.identityPaths = [ "/home/nixos/.ssh/bbk_main" ];
  #
  age.secrets.anthropic-env = {
    file = ../secrets/anthropic.env.age;
    owner = "nixos";
    group = "users";
    mode = "600";
  };

  environment.variables = {
    ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
    ANTHROPIC_AUTH_TOKEN = builtins.readFile config.age.secrets.anthropic-env.path;
    ANTHROPIC_MODEL = "deepseek-chat";
    ANTHROPIC_SMALL_FAST_MODEL = "deepseek-chat";
  };
}
