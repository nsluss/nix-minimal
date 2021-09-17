{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs)
    callPackage
    dockerTools
    cacert;

  package = callPackage ./. {};
in
{
  image = dockerTools.buildImage {
    name = "nix-minimal";
    tag = "latest";
    contents = [
      package
      cacert
    ];
    config = {
      Cmd = [ "${package}/bin/nix-minimal" ];
      ExposedPorts = {
        "8000/tcp" = {};
      };
    };
  };
  exe = package;
}