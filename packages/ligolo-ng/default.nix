{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  stdenv,
}:
let
  version = "0.7.5";
  src = fetchFromGitHub {
    owner = "nicocha30";
    repo = "ligolo-ng";
    rev = "v${version}";
    hash = "sha256-BU3gBUNOTjpAANkvzPcgsZrly+TkbG86LHtZf93uxeY=";
  };

  vendorHash = "sha256-v6lHY3s1TJh8u4JaTa9kcCj+1pl01zckvTVeLk8TZ+w=";

  proxy = buildGoModule {
    pname = "ligolo-proxy";
    inherit version src vendorHash;
    subPackages = ["cmd/proxy"];
    env.CGO_ENABLED = "0";
  };

  agent-linux = buildGoModule {
    pname = "ligolo-agent-linux";
    inherit version src vendorHash;
    subPackages = ["cmd/agent"];
    env.CGO_ENABLED = "0";
  };

  agent-win = buildGoModule {
    pname = "ligolo-agent-win";
    inherit version src vendorHash;
    subPackages = ["cmd/agent"];

    buildPhase = ''
      runHook preBuild
      export GOCACHE="$TMPDIR/go-cache"
      GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -v -o agent.exe ./cmd/agent
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp agent.exe $out/bin/
    '';
  };
in
stdenv.mkDerivation {
  pname = "ligolo-ng-binaries";
  inherit version;

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/bin $out/arsenal/networking/{lin,win}

    cp ${proxy}/bin/proxy $out/arsenal/networking/lin/ligolo-proxy
    cp ${agent-linux}/bin/agent $out/arsenal/networking/lin/ligolo-agent
    chmod +x $out/arsenal/networking/lin/*

    cp ${agent-win}/bin/agent.exe $out/arsenal/networking/win/ligolo-agent.exe

    ln -s $out/arsenal/networking/lin/ligolo-proxy $out/bin/ligolo-proxy
  '';

  meta = with lib; {
    description = "Tunneling/pivoting tool using TUN interfaces";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
