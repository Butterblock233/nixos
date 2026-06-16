{ pkgs-unstable, pkgs, ... }:

let
  # nvidia-cdi-hook ==> `nvidia-ctk hook`
  nvidia-cdi-hook-wrapper = pkgs.writeShellScriptBin "nvidia-cdi-hook" ''
    exec ${pkgs-unstable.nvidia-container-toolkit}/bin/nvidia-ctk hook "$@"
  '';
in
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  environment.variables = {
    MESA_LOADER_DRIVER_NAME = "zink";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false; # Disable under WSL2
    suppressNvidiaDriverAssertion = true;
  };

  # /usr/bin/nvidia-cdi-hook -> wrapped script
  systemd.tmpfiles.rules = [
    "L+ /usr/bin/nvidia-cdi-hook - - - - ${nvidia-cdi-hook-wrapper}/bin/nvidia-cdi-hook"
    "L+ /usr/bin/nvidia-ctk - - - - ${pkgs-unstable.nvidia-container-toolkit}/bin/nvidia-ctk"
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features.cdi = true;
    };
  };

  environment.systemPackages = [
    pkgs-unstable.nvidia-container-toolkit
    nvidia-cdi-hook-wrapper
  ];
}
