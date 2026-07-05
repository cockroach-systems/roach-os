# python env shell - makes pip/venv work with native system extensions
# usage: pyshell (or: nix-shell /run/current-system/sw/share/shells/python-env.nix)
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = [pkgs.python3];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.zlib
    pkgs.stdenv.cc.cc.lib
    pkgs.openssl
    pkgs.libffi
  ];
}
