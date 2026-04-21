{
  lib,
  stdenv,
  fetchurl,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "netcat-win";
  version = "1.12";

  src = fetchurl {
    url = "https://eternallybored.org/misc/netcat/netcat-win32-1.12.zip";
    sha256 = "1cblsbk7gv1n1zqj997iiqms4kagzyz7cbbl2rasnq5cvfhqags1";
  };

  nativeBuildInputs = [ pkgs.unzip ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/arsenal/networking/win
    unzip -q $src -d .
    cp nc.exe $out/arsenal/networking/win/nc.exe
    cp nc64.exe $out/arsenal/networking/win/nc64.exe
  '';

  meta = with lib; {
    description = "Windows netcat binaries (32 and 64 bit)";
    homepage = "https://eternallybored.org/misc/netcat/";
    platforms = platforms.all;
  };
}
