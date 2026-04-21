{
  lib,
  stdenv,
  makeWrapper,
  bash,
}:
stdenv.mkDerivation rec {
  pname = "rshells";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  dontBuild = true;
  dontConfigure = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/arsenal/rshells/{lin,win}

    for script in "$src"/lin/*; do
      [ -f "$script" ] || continue
      cp "$script" "$out/arsenal/rshells/lin/"
      chmod +x "$out/arsenal/rshells/lin/$(basename "$script")"
    done

    for script in "$src"/win/*; do
      [ -f "$script" ] || continue
      cp "$script" "$out/arsenal/rshells/win/"
      chmod +x "$out/arsenal/rshells/win/$(basename "$script")"
    done
  '';

  meta = with lib; {
    description = "reverse shells 4 naughty boys and girls (and whatevers in between)";
    platforms = platforms.all;
  };
}
