{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ruby
    (python3.withPackages (ps: with ps; [
      impacket
      requests
      pycryptodome
      ldap3
      pip
      virtualenv
      aerospike
    ]))
    go
    php
    dos2unix
  ];

  # Allows venvs to link against system libraries (needed for compiled deps)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    stdenv.cc.cc.lib  # libstdc++
    openssl
    libffi
    glib
    xz
    bzip2
  ];
}