{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  removeReferencesTo,
}:
buildGoModule (finalAttrs: {
  pname = "vulnx";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "vulnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HejAK/KXpQ9HouA3JpX7MoMzMUoMmKX7eEKwMGfgSx4=";
  };

  vendorHash = "sha256-WVskArdIieEof/GDlzEZbY4QDYfAQyP0+Le24q+Kfu0=";

  subPackages = ["cmd/vulnx/"];

  ldflags = ["-s" "-w"];

  env.CGO_ENABLED = "0";

  nativeBuildInputs = [removeReferencesTo];

  # 25.05's Go leaves a spurious toolchain path string in the binary; strip it
  # (Go binaries are static and never need the toolchain at runtime).
  postInstall = ''
    remove-references-to -t ${go} "$out/bin/vulnx"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  # source-built, not a fetched binary
  passthru.prebuilt = false;

  meta = with lib; {
    description = "ProjectDiscovery vulnerability-intelligence CLI (CVE search)";
    homepage = "https://github.com/projectdiscovery/vulnx";
    license = licenses.mit;
    mainProgram = "vulnx";
    platforms = platforms.linux;
  };
})
