{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "pspy";
  version = "1.2.1";

  srcs = [
    (fetchurl {
      url = "https://github.com/DominicBreuker/pspy/releases/download/v${version}/pspy64";
      sha256 = "sha256-yT8ppcwTR725DhShJCTmRpyM/qmiC4ALwkl1XwBDo7s=";
    })
    (fetchurl {
      url = "https://github.com/DominicBreuker/pspy/releases/download/v${version}/pspy32";
      sha256 = "sha256-HjisCdeFGyLhaYCrxY+Tyr3EoChZxWooEKpRkwJ31FA=";
    })
  ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/arsenal/privesc/lin
    cp ${builtins.elemAt srcs 0} $out/arsenal/privesc/lin/pspy64
    cp ${builtins.elemAt srcs 1} $out/arsenal/privesc/lin/pspy32
    chmod +x $out/arsenal/privesc/lin/*
  '';

  meta = with lib; {
    description = "Monitor Linux processes without root";
    homepage = "https://github.com/DominicBreuker/pspy";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
