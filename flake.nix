{
  description = "RoachOS — NixOS offensive security modules by cockroach.systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {self, nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosModules.default = import ./modules;

    packages.${system} = import ./packages {inherit pkgs;};
  };
}
