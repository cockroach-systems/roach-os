{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "linpeas";
  version = "20251101";

  src = fetchurl {
    url = "https://github.com/peass-ng/PEASS-ng/releases/download/20251101-a416400b/linpeas.sh";
    sha256 = "1j3lfmlcj8ifrfvaszhvrgl9yg477094pbgx12bmfvmmvmj2yq0c";
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  dontPatchShebangs = true;

  passthru.prebuilt = false;

  installPhase = ''
    mkdir -p $out/arsenal/privesc/lin
    cp ${src} $out/arsenal/privesc/lin/linpeas.sh
    chmod +x $out/arsenal/privesc/lin/linpeas.sh
  '';

  meta = with lib; {
    description = "Linux Privilege Escalation Awesome Script";
    homepage = "https://github.com/peass-ng/PEASS-ng";
    platforms = platforms.linux;
  };
}
