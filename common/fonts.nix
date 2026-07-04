{ pkgs, ... }:
let
  harmonyos-sans = (
    pkgs.stdenv.mkDerivation rec {
      pname = "harmonyos-sans";
      version = "2.0";

      # Source a reliable mirror or your own local tarball
      src = pkgs.fetchzip {
        url = "https://github.com/huawei-fonts/HarmonyOS-Sans/raw/refs/heads/main/HarmonyOS%20Sans.zip";
        name = "harmonyos-sans";
        sha256 = "sha256-a5Qt10A+BoO3CPrXiV/ctvT+uoTWDZ1TrvD2t3BKot4=";
        # sha256 = "sha256:0000000000000000000000000000000000000000000000000000"; # Replace with correct hash
      };

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        find . -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
      '';
    }
  );
in
{
  fonts.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-serif
	pkgs.jetbrains-mono
	pkgs.noto-fonts-color-emoji
	# harmonyos-sans
  ];
}
