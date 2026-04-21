{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rlwrap
    exiftool
    filezilla
  ];
}
