{
  description = "Marzban telegram bot";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      all = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          marzbanbot = pkgs.callPackage ./package.nix { };
        in {
          packages = {
            inherit marzbanbot;
            default = marzbanbot;
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [ marzbanbot ];
            packages = [ pkgs.poetry ];
          };
        });
    in {
      nixosModules.marzbanbot = import ./module.nix;
      nixosModules.default = self.nixosModules.marzbanbot;

      overlays.marzbanbot = (final: prev: { marzbanbot = all.packages.${prev.system}.marzbanbot; });
      overlays.default = self.overlays.marzbanbot;
    } // all;
}
