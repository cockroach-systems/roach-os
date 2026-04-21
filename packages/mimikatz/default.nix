{
  stdenv,
  lib,
  fetchzip,
}:
let
  version = "2.2.0-20220919";
  src = fetchzip {
    url = "https://github.com/gentilkiwi/mimikatz/releases/download/${version}/mimikatz_trunk.zip";
    hash = "sha256-wmatI/rEMziBdNiA3HE3MJ0ckdpvsD+LdbB7SKOYdI0=";
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "mimikatz";
  inherit version;

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/arsenal/active_directory
    cp ${src}/x64/mimikatz.exe $out/arsenal/active_directory/mimikatz.exe
  '';

  meta = with lib; {
    description = "Windows credential dumper";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
