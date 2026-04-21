{pkgs, ...}: let
  shells = pkgs.callPackage ../../packages/shells {};
in {
  environment.systemPackages = [shells];

  system.activationScripts.shells = ''
    mkdir -p /usr/share
    ln -sfn ${shells}/shells /usr/share/shells
  '';

  environment.shellAliases = {
    pyshell = "nix-shell /usr/share/shells/python-env.nix";
    py2shell = "nix-shell /usr/share/shells/python2-env.nix";
  };
}
