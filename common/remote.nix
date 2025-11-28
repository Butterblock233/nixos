{
  pkgs,
  ...
}:
{
  services.openssh = {
    # Basically, WSL distro does not need remote login service using sshd
    enable = false;
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
