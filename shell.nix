{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    beam.packages.erlangR26.elixir_1_16
    nodejs_20
    yarn
  ];
}
