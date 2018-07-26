{ pkgs }:

self: super:

with { inherit (pkgs.stdenv) lib; };

with pkgs.haskell.lib;

{
  
  siphon = dontCheck super.siphon;

  contiguous = ( self.callPackage ./deps/contiguous.nix {} );

  primitive = self.callPackage ./deps/primitive.nix {};
  
  quantification = self.callPackage ./deps/quantification.nix {};

  primitive-containers =
    doJailbreak
      ( dontBenchmark
        ( dontHaddock
          ( dontCheck
            ( self.callPackage ./deps/primitive-containers.nix {}
            )
          )
        )
      ); 
  
  geolite-api = (
    with rec {
      geolite-apiSource = pkgs.lib.cleanSource ../.;
      geolite-apiBasic = self.callCabal2nix "geolite-api" geolite-apiSource {};
    };
    overrideCabal geolite-apiBasic (old: {
    })
  );
}