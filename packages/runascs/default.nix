{
  stdenv,
  lib,
  fetchzip,
}:
let
  version = "1.5";
  src = fetchzip {
    url = "https://github.com/antonioCoco/RunasCs/releases/download/v${version}/RunasCs.zip";
    hash = "sha256-1XaQ+Esqq+k2SHtVyyaFNU5mi4FOnPgK8LRuOw8XNEM=";
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "runascs";
  inherit version;

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/arsenal/lateral/win
    cp ${src}/RunasCs.exe $out/arsenal/lateral/win/RunasCs.exe
  '';

  meta = with lib; {
    description = "RunasCs - run commands as another user";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
