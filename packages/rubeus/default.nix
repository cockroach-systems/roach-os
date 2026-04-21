# no public release binaries — needs a binary server or self-compiled .exe
{
  stdenv,
  lib,
  fetchurl,
  binaryServer,
}:
let
  rubeus-exe = fetchurl {
    url = "${binaryServer}/rubeus64.exe";
    sha256 = "sha256-xbwdaZI+lh+ailVuzcczframuTm1SI/OTwz8WEmOnP0=";
  };
in
  stdenv.mkDerivation {
    pname = "rubeus";
    version = "2.0";

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    passthru.prebuilt = true;

    installPhase = ''
      mkdir -p $out/arsenal/active_directory
      cp ${rubeus-exe} $out/arsenal/active_directory/rubeus64.exe
    '';

    meta = with lib; {
      description = "Rubeus - Kerberos abuse toolkit";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  }
