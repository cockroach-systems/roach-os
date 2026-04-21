{
  stdenv,
  lib,
  fetchurl,
}:
let
  powerview-ps1 = fetchurl {
    url = "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1";
    hash = "sha256-UH6GZsI5OXVhxYYJ9+pWnJxJ3buQDNJg5+QrAtA8/Yc=";
  };
in
stdenv.mkDerivation {
  pname = "powerview";
  version = "3.0";

  dontUnpack = true;
  dontBuild = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/arsenal/active_directory
    cp ${powerview-ps1} $out/arsenal/active_directory/PowerView.ps1
  '';

  meta = with lib; {
    description = "PowerView - PowerShell AD recon tool";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
