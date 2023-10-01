{
  description = "KlipperZscreen";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
    zls-master.url = "github:zigtools/zls/master";

    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      overlays = [
        (final: prev: {
          zig = inputs.zig.packages.${prev.system}.master;
        })
      ];
      systems = builtins.attrNames inputs.zig.packages;
    in flake-utils.lib.eachSystem systems (system:
      let pkgs = import nixpkgs { inherit overlays system; };
      in with pkgs; rec {
        devShells.default = pkgs.mkShell {
          buildInputs = [ zig SDL2 pkg-config ];
        };
      });
}
