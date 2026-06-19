{ lib, pkgs, ... }:
let
  wsl-lib = pkgs.runCommand "wsl-lib" { } ''
    mkdir -p "$out/lib"
    # # We can't just symlink the lib directory, because it will break merging with other drivers that provide the same directory
    ln -s /usr/lib/wsl/lib/libcudadebugger.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libcuda.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libcuda.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libcuda.so.1.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libd3d12core.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libd3d12.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libdxcore.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvcuvid.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvcuvid.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvdxdlkernels.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvidia-encode.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvidia-encode.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvidia-ml.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvidia-opticalflow.so "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvidia-opticalflow.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvoptix.so.1 "$out/lib"
    ln -s /usr/lib/wsl/lib/libnvwgf2umx.so "$out/lib"
    ln -s /usr/lib/wsl/lib/nvidia-smi "$out/lib"
  '';

  nvidia-cdi-hook-wrapper = pkgs.writeShellScriptBin "nvidia-cdi-hook" ''
    exec ${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk hook "$@"
  '';
in
{
  programs.nix-ld = {
    enable = true;
    libraries = [
      wsl-lib
      pkgs.vulkan-loader
      pkgs.libGL
      pkgs.libX11
      pkgs.libXcursor
      pkgs.libXi
      pkgs.libXrandr
    ];
  };
  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };
  hardware.nvidia-container-toolkit = {
    enable = true;
    suppressNvidiaDriverAssertion = true;
    mount-nvidia-executables = true;
  };
  hardware.graphics = {
    enable = true;
  };
  environment.sessionVariables = {
    LD_LIBRARY_PATH = [
      "/run/opengl-driver/lib"
      "/usr/lib/wsl/lib"
    ];

    MESA_D3D12_DEFAULT_ADAPTER_NAME = "GPU";
  };
  # Override the default CDI generator for the WSL + NixOS + NVIDIA stack,
  # which lacks native support and triggers host path pollution or errors in edge cases.
  systemd.services."nvidia-container-toolkit-cdi-generator" = {
    serviceConfig.ExecStart = lib.mkForce (
      pkgs.writeShellScript "wsl-cdi-generator" ''
        mkdir -p /run/cdi
        ${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk cdi generate --format json --mode wsl --output=/run/cdi/nvidia-container-toolkit.json
      ''
    );
  };
  systemd.tmpfiles.rules = [
    "L+ /usr/bin/nvidia-cdi-hook - - - - ${nvidia-cdi-hook-wrapper}/bin/nvidia-cdi-hook"
    "L+ /usr/bin/nvidia-ctk - - - - ${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk"
  ];

}
