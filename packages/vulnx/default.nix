{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "vulnx";
  version = "unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "vulnx";
    rev = "ee62eca9109342531fe5b90f15b1f5b6fe247996";
    hash = "sha256-5VedtfmPz9ZWO71D9vdjjd+fRG4VvRhb6K8bdfheRXA=";
  };

  vendorHash = "sha256-WVskArdIieEof/GDlzEZbY4QDYfAQyP0+Le24q+Kfu0=";

  subPackages = ["cmd/vulnx"];

  meta = with lib; {
    description = "CVE exploration tool by ProjectDiscovery";
    homepage = "https://github.com/projectdiscovery/vulnx";
    license = licenses.mit;
  };
}
