{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "go-windapsearch";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/ropnop/go-windapsearch/releases/download/v${version}/windapsearch-linux-amd64";
    sha256 = "1h9nhqnnc5kva9dbyn9vnndvg7rhf94l417nnij8s5924igbraqm";
  };

  nativeBuildInputs = [autoPatchelfHook];

  dontUnpack = true;

  passthru.prebuilt = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/windapsearch
    chmod +x $out/bin/windapsearch
  '';

  meta = with lib; {
    description = "Active Directory Domain enumeration through LDAP";
    homepage = "https://github.com/ropnop/go-windapsearch";
  };
}
