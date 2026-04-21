{
  stdenv,
  lib,
  fetchzip,
}:
let
  version = "2.5.9";
  src = fetchzip {
    url = "https://github.com/BloodHoundAD/SharpHound/releases/download/v${version}/SharpHound-v${version}.zip";
    hash = "sha256-vTt2gNlwPbONoVHNp47GaLJBsWBWR26aCTSaFTg5Qig=";
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "sharphound";
  inherit version;

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/arsenal/active_directory
    cp ${src}/SharpHound.exe $out/arsenal/active_directory/SharpHound.exe
    cp ${src}/SharpHound.ps1 $out/arsenal/active_directory/SharpHound.ps1
  '';

  meta = with lib; {
    description = "BloodHound data collector for Active Directory";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
