{
  description = "Extra packages by me@romatthe.dev";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... } @ inputs : {

    packages.x84_64-linux.sway-borders = inputs.nixpkgs.legacyPackages.${"x86_64-linux"}.callPackage ./pkg/sway-borders {};
    
    overlay = final: prev:
        let
          extra = rec {
            sway-borders = prev.callPackage ./pkg/sway-borders {};
          };
        in
          extra // { inherit extra; };
  };
}
