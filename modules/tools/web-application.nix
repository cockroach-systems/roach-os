{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    burpsuite
    ffuf
    whatweb
    git-dumper
    wpscan
  ];
}

