{ pkgs, ... }:

{
  languages.rust.enable = true;

  packages = [
    pkgs.lean4
    pkgs.typst
    pkgs.cargo-watch
    pkgs.jq
  ];
}
