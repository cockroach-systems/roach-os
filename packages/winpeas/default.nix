{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "winpeas";
  version = "20251101";

  winpeas-bat = fetchurl {
    url = "https://github.com/peass-ng/PEASS-ng/releases/download/20251101-a416400b/winPEAS.bat";
    sha256 = "0fxpybsbaxfv419sin5xrcrhcqhngisz0q241w27wv6ssvr7vrvn";
  };
  winpeas-x64 = fetchurl {
    url = "https://github.com/peass-ng/PEASS-ng/releases/download/20251101-a416400b/winPEASx64.exe";
    sha256 = "0fybf9fvvfwxgllr4nj5qcrnnldqkqlr7gcxig1z01lv7wkfk9wf";
  };
  winpeas-x86 = fetchurl {
    url = "https://github.com/peass-ng/PEASS-ng/releases/download/20251101-a416400b/winPEASx86.exe";
    sha256 = "1zsjllq9mhz3572x154fx7zd62bg97c4wr5vb6sgzfh78rmj0cpl";
  };
  winpeas-any = fetchurl {
    url = "https://github.com/peass-ng/PEASS-ng/releases/download/20251101-a416400b/winPEASany.exe";
    sha256 = "1a4j9158kfd4b4jr6k2ksgnyb72fs38y1vyy1ms7zn3bfrgw7w52";
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/arsenal/privesc/win
    cp ${winpeas-bat} $out/arsenal/privesc/win/winPEAS.bat
    cp ${winpeas-x64} $out/arsenal/privesc/win/winPEASx64.exe
    cp ${winpeas-x86} $out/arsenal/privesc/win/winPEASx86.exe
    cp ${winpeas-any} $out/arsenal/privesc/win/winPEASany.exe
  '';

  meta = with lib; {
    description = "Windows Privilege Escalation Awesome Script";
    homepage = "https://github.com/peass-ng/PEASS-ng";
    platforms = platforms.all;
  };
}
