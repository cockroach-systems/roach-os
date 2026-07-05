# python2 env shell - for legacy exploits
# usage: py2shell (or: nix-shell /usr/share/shells/python2-env.nix)
{pkgs ? import <nixpkgs> {
  config.permittedInsecurePackages = ["python-2.7.18.8"];
}}:
pkgs.mkShell {
  packages = [pkgs.python2];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.zlib
    pkgs.stdenv.cc.cc.lib
    pkgs.openssl
    pkgs.libffi
  ];
}
