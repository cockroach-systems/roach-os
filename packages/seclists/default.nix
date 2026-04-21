{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "seclists";
  version = "2024.4";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "SecLists";
    rev = "2024.4";
    sha256 = "sha256-mGXCMmHbNKxXNDcfr0rtsyfmX4tygeIN5XKQYip5O8Y=";
  };

  dontBuild = true;
  dontConfigure = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/arsenal/wordlists
    cp -r * $out/arsenal/wordlists/

    # extract rockyou for quick access
    tar -xzf $out/arsenal/wordlists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C $out/arsenal/wordlists


  '';

  meta = with lib; {
    description = "Collection of multiple types of lists used during security assessments";
    homepage = "https://github.com/danielmiessler/SecLists";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
