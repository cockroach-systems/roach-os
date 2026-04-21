{pkgs}:
pkgs.python312Packages.buildPythonApplication rec {
  pname = "pywhisker";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "ShutdownRepo";
    repo = "pywhisker";
    rev = "main";
    hash = "sha256-hTY2Ff+LDnyL6l7rovtl/hMhnURkUpeCb+MPplWZk4M=";
  };

  propagatedBuildInputs = with pkgs.python312Packages; [
    impacket
    ldap3
    ldapdomaindump
    dsinternals
    rich
  ];

  # No tests in repo
  doCheck = false;
}
