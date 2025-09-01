{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.openssh = {
    enable = true;
    settings = {
    };
    ports = [ 22 ];
  };

  programs.ssh = {
    startAgent = true;
    # extraConfig = '''';
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    openssh
    ssh-copy-id
    sshfs
    rsync
    rclone
  ];
}
