{
  inputs = {
    # using unstable branch for the latest packages of nixpkgs
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

      in
      {
        devShell = pkgs.mkShell
          {
            buildInputs = [
              pkgs.arduino-cli
              pkgs.arduino-language-server
              pkgs.clang
              pkgs.gcc
              pkgs.gnumake
            ];
            # Change the prompt to show that you are in a devShell
            shellHook = "export PS1='\\[\\e[1;34m\\]dev > \\[\\e[0m\\]'";
          };
      });
}
