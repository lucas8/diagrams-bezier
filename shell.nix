{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, array, base, containers, diagrams
      , diagrams-cairo, stdenv, transformers, QuickCheck
      , hspec
      }:
      mkDerivation {
        pname = "bezier";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = false;
        executableHaskellDepends = [
          array base containers diagrams diagrams-cairo transformers
          QuickCheck hspec
        ];
        buildDepends = with pkgs; [ cabal-install ];
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
