{
  pkgs,
  ...
}:
{
  programs.ssh = {
    # ssh options has updated science 25.11
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
