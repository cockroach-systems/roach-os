{
  stdenv,
  lib,
  fetchurl,
}: let
  version = "1.20";
  base = "https://github.com/BeichenDream/GodPotato/releases/download/V${version}";

  godpotato-net2 = fetchurl {
    url = "${base}/GodPotato-NET2.exe";
    hash = "sha256-MCeiEicpVymL9NMlBTcPpj+xYtampuwJGvnXYmMXqFg=";
  };
  godpotato-net35 = fetchurl {
    url = "${base}/GodPotato-NET35.exe";
    hash = "sha256-MCeiEicpVymL9NMlBTcPpj+xYtampuwJGvnXYmMXqFg=";
  };
  godpotato-net4 = fetchurl {
    url = "${base}/GodPotato-NET4.exe";
    hash = "sha256-mo6dWHtXDUB08cgxexY6qNDFZu/YjylNnYW8d3Y1Kig=";
  };
in
  stdenv.mkDerivation {
    pname = "godpotato";
    inherit version;

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    passthru.prebuilt = true;

    installPhase = ''
      mkdir -p $out/arsenal/privesc/win
      cp ${godpotato-net2} $out/arsenal/privesc/win/GodPotato-NET2.exe
      cp ${godpotato-net35} $out/arsenal/privesc/win/GodPotato-NET35.exe
      cp ${godpotato-net4} $out/arsenal/privesc/win/GodPotato-NET4.exe
    '';

    meta = with lib; {
      description = "Windows privilege escalation via SeImpersonatePrivilege";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  }
