{
  pkgs,
  binaryServer ? "http://localhost:8080",
  allowPrebuilt ? true,
}: let
  # define once, that's it
  packages = {
    linpeas = pkgs.callPackage ./linpeas {};
    winpeas = pkgs.callPackage ./winpeas {};
    netcat-win = pkgs.callPackage ./netcat-win {};
    go-windapsearch = pkgs.callPackage ./go-windapsearch {};
    seclists = pkgs.callPackage ./seclists {};
    mimikatz = pkgs.callPackage ./mimikatz {};
    sharphound = pkgs.callPackage ./sharphound {};
    rubeus = pkgs.callPackage ./rubeus {inherit binaryServer;};
    powerview = pkgs.callPackage ./powerview {};
    godpotato = pkgs.callPackage ./godpotato {};
    ligolo-ng-binaries = pkgs.callPackage ./ligolo-ng {};
    runascs = pkgs.callPackage ./runascs {};
    custom-scripts = pkgs.callPackage ./custom-scripts {};
    rshells = pkgs.callPackage ./rshells {};
    sliver = pkgs.callPackage ./sliver {};
    pspy = pkgs.callPackage ./pspy {};
    rockyou = pkgs.callPackage ./rockyou {};
    webshells = pkgs.callPackage ./webshells {};
    vulnx = pkgs.callPackage ./vulnx {};
    pywhisker = pkgs.callPackage ./pywhisker {};
  };

  allowed = pkg: allowPrebuilt || !(pkg.passthru.prebuilt or false);

  arsenalPackages = with packages; [
    linpeas
    winpeas
    pspy
    godpotato
    runascs
    mimikatz
    sharphound
    rubeus
    powerview
    ligolo-ng-binaries
    netcat-win
    rshells
    webshells
    seclists
    rockyou
  ];
in
  packages
  // {
    arsenal = pkgs.symlinkJoin {
      name = "arsenal";
      paths = builtins.filter allowed arsenalPackages;
    };
  }
