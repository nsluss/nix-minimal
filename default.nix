{ haskellPackages ? (import <nixpkgs> {}).haskellPackages }:
  haskellPackages
    .callCabal2nix "nix-minimal" ./. {}