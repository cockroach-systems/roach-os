{
  lib,
  stdenv,
  makeWrapper,
  bash,
}:
stdenv.mkDerivation rec {
  pname = "custom-scripts";
  version = "1.0";

  src = ./scripts;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    
    # Copy all scripts from the scripts directory
    if [ -d "$src" ]; then
      for script in "$src"/*; do
        if [ -f "$script" ]; then
          cp "$script" "$out/bin/"
          # Make sure scripts are executable
          chmod +x "$out/bin/$(basename "$script")"
          
          # Wrap bash/sh scripts to ensure they have the right interpreter
          if head -n1 "$script" | grep -E '^#!/bin/(bash|sh)' > /dev/null; then
            wrapProgram "$out/bin/$(basename "$script")" \
              --prefix PATH : ${lib.makeBinPath [ bash ]}
          fi
        fi
      done
    fi
  '';

  meta = with lib; {
    description = "Custom helper scripts for security research";
    platforms = platforms.all;
  };
}