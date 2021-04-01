{
  description = "Extra packages by me@romatthe.dev";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  
  outputs = { self, nixpkgs, flake-utils }: {
    
    overlay = final: prev: {
      nixpkgs-extra = {
        sway-borders        = prev.callPackage ./pkgs/sway-borders {};
        whitesur-gtk-theme  = prev.callPackage ./pkgs/whitesur-gtk-theme {};
        whitesur-icon-theme = prev.callPackage ./pkgs/whitesur-icon-theme {};
      };  
    };
    
  };
}
