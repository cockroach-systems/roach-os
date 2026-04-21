{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "webshells";
  version = "1.0";

  src = ./php;

  dontBuild = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/arsenal/webshells/php
    cp -r $src/* $out/arsenal/webshells/php/
  '';

  meta = with lib; {
    description = "PHP webshells collection";
  };
}
