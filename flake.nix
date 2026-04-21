{
  description = "RoachOS — NixOS offensive security modules by cockroach.systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {self, nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    custom-packages = import ./packages {inherit pkgs;};
  in {
    nixosModules.default = import ./modules;

    packages.${system} = {
      inherit (custom-packages)
        linpeas winpeas netcat-win go-windapsearch seclists
        mimikatz sharphound powerview godpotato ligolo-ng-binaries
        runascs custom-scripts rshells sliver pspy rockyou
        webshells vulnx pywhisker arsenal;
    };
  };
}
