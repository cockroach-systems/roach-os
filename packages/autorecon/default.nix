{pkgs}:
pkgs.python312Packages.buildPythonApplication rec {
  pname = "autorecon";
  version = "2.0.36";

  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "Tib3rius";
    repo = "AutoRecon";
    # no release tags upstream; pin the commit matching version 2.0.36
    rev = "e7e98f60bdc5fb1695159c1bbcdfdf2746d30fa6";
    hash = "sha256-xSRfsfLRYt7jS5Jpp6fz5/Kj2DiNI3hgUbUI9w3AHkw=";
  };

  build-system = [pkgs.python312Packages.poetry-core];

  # upstream pins upper bounds (impacket <0.11, psutil <6) that nixpkgs has
  # moved past; AutoRecon works fine with the newer versions
  pythonRelaxDeps = ["impacket" "psutil"];

  propagatedBuildInputs = with pkgs.python312Packages; [
    platformdirs
    colorama
    impacket
    psutil
    requests
    toml
    unidecode
  ];

  nativeBuildInputs = [pkgs.makeWrapper];

  # AutoRecon shells out to external recon tools at runtime; put the common
  # ones on its PATH so it works standalone rather than relying on the host.
  runtimeTools = with pkgs; [
    nmap
    curl
    samba # smbclient / smbmap-style enumeration
    nikto
    gobuster
    feroxbuster
    enum4linux-ng
    onesixtyone
    sslscan
    whatweb
    wkhtmltopdf
    dnsrecon
    redis
    net-snmp # snmpwalk
    sipvicious
    dirb
  ];

  postFixup = ''
    wrapProgram $out/bin/autorecon \
      --prefix PATH : ${pkgs.lib.makeBinPath runtimeTools}
  '';

  # No test suite in repo
  doCheck = false;

  # source-built, not a fetched binary
  passthru.prebuilt = false;

  meta = with pkgs.lib; {
    description = "Multi-threaded network reconnaissance tool for automated service enumeration";
    homepage = "https://github.com/Tib3rius/AutoRecon";
    license = licenses.gpl3Only;
    mainProgram = "autorecon";
    platforms = platforms.linux;
  };
}
