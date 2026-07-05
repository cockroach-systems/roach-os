{stdenv}:
stdenv.mkDerivation {
  pname = "nix-shells";
  version = "1.0.0";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/shells
    for f in *.nix; do
      [ "$f" != "default.nix" ] && cp "$f" $out/shells/
    done
  '';
}
