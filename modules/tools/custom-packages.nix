{pkgs, ...}: let
  custom-packages = import ../../packages {inherit pkgs;};
in {
  environment.systemPackages = with custom-packages; [
    go-windapsearch
    seclists
    arsenal
    mimikatz
    godpotato
    ligolo-ng-binaries
    custom-scripts
    sliver
    pspy
    vulnx
  ];

  # Make arsenal accessible at /arsenal
  system.activationScripts.arsenal = ''
    ln -sfn ${custom-packages.arsenal}/arsenal /arsenal
  '';
}
