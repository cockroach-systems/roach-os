{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "vulnx";
  version = "unstable-2025-02-01";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "cvemap";
    rev = "main";
    hash = "sha256-id9czIrS0BhpI94nQibtPOnWJIj+JPj+XgvEgU3cbfU=";
  };

  vendorHash = "sha256-WVskArdIieEof/GDlzEZbY4QDYfAQyP0+Le24q+Kfu0=";

  subPackages = ["cmd/vulnx"];

  meta = with lib; {
    description = "CVE exploration tool by ProjectDiscovery";
    homepage = "https://github.com/projectdiscovery/cvemap";
    license = licenses.mit;
  };
}
