{
  stdenv,
  lib,
  fetchurl,
}: let
  version = "1.7.0";

  server = fetchurl {
    url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-server_linux-amd64";
    sha256 = "sha256-sazhtuKQGouQfZb/rMhX7VcsEZWi6YyI4xgZ1U/lBA8=";
  };

  client = fetchurl {
    url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-client_linux-amd64";
    sha256 = "sha256-7Y6jS879KNXOtqawDl+SZpFnQv7FZpH9MHbOhrCWKyw=";
  };
in
  stdenv.mkDerivation {
    pname = "sliver";
    inherit version;

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    passthru.prebuilt = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp ${server} $out/bin/sliver-server
      cp ${client} $out/bin/sliver-client
      chmod +x $out/bin/sliver-{server,client}
      runHook postInstall
    '';

    meta = with lib; {
      description = "Adversary Emulation Framework";
      homepage = "https://github.com/BishopFox/sliver";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  }
