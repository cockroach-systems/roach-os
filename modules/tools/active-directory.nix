{pkgs, ...}: let
  custom-packages = import ../../packages {inherit pkgs;};
in {
  environment.systemPackages = with pkgs; [
    kerbrute
    python312Packages.impacket
    responder
    ldapdomaindump
    krb5
    bloodhound-py
    custom-packages.pywhisker
  ];
}
