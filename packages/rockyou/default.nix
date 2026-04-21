{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "rockyou";
  version = "1.0";

  src = ./rockyou.txt;

  dontUnpack = true;
  dontBuild = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/arsenal/wordlists
    cp $src $out/arsenal/wordlists/rockyou.txt
  '';

  meta = with lib; {
    description = "Rockyou password wordlist";
    platforms = platforms.all;
  };
}
