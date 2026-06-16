{ pkgs, ... }:
let
  wsl-lib = pkgs.runCommand "wsl-lib" { } ''
    mkdir -p "$out/lib"
    # 注意：不能直接把整目录软链接过去，否则会破坏与其他提供相同目录的驱动的合并机制
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
in
{
  # environment.sessionVariables.LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
  # virtualisation.docker.enable = true; # This option is deprecated, please set hardware.nvidia-container-toolkit.enable instead.

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = true;
  hardware.nvidia-container-toolkit.mount-nvidia-executables = false;
  # hardware.nvidia-container-toolkit.mount-nvidia-executables=false;
  # Prevents: - Option enableNvidia on x86_64 requires 32-bit support libraries
  # Regular Docker
  virtualisation.docker.daemon.settings.features = {
    cdi = true;
  };
  # If using Rootless Docker
  # virtualisation.docker.rootless.daemon.settings.features.cdi = true;
  programs.nix-ld = {
    enable = true;
    libraries = [ wsl-lib ];
  };
}
