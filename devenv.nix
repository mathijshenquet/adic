{ pkgs, ... }:

{
  languages.rust.enable = true;

  packages = [
    pkgs.typst
    pkgs.cargo-watch
    pkgs.jq
  ];
}
