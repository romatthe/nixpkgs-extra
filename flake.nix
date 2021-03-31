{
  description = "Extra packages by me@romatthe.dev";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  
  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachSystem ["x86_64-linux"] (system: {

    #    packages.x86_64-linux.sway-borders =
    packages.sway-borders = 
      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation {
        name = "sway-borders";
        version = "1.5.1";
  
        src = fetchFromGitHub {
          owner = "fluix-dev";
          repo = "sway-borders";
          rev = "a5eaab1ba61f881e50561271bdd94bf3f3912093";
          sha256 = "1sljf5yk1flyd8xk0cjmnr0iw74mm1c67xfpnfbwma4mzizrpqpc";
        };

        patches =  [
          ./pkgs/sway-borders/patches/sway-config-no-nix-store-references.patch
          ./pkgs/sway-borders/patches/load-configuration-from-etc.patch
          ./pkgs/sway-borders/patches/bump-wlroots-version.patch
      
          (substituteAll {
            src = ./pkgs/sway-borders/patches/fix-paths.patch;
            inherit swaybg;
          })
        ];

        nativeBuildInputs = [
          meson ninja pkg-config wayland scdoc
        ];

        buildInputs = with pkgs; [
          wayland libxkbcommon pcre json_c dbus libevdev
          pango cairo libinput libcap pam gdk-pixbuf librsvg
          wlroots wayland-protocols
        ];
    
        mesonFlags = [
          "-Ddefault-wallpaper=false"
        ];

        meta = with pkgs.lib; {
          description = "An i3-compatible tiling Wayland compositor";
          longDescription = ''
            Sway is a tiling Wayland compositor and a drop-in replacement for the i3
            window manager for X11. It works with your existing i3 configuration and
            supports most of i3's features, plus a few extras.
            Sway allows you to arrange your application windows logically, rather
            than spatially. Windows are arranged into a grid by default which
            maximizes the efficiency of your screen and can be quickly manipulated
            using only the keyboard.
          '';
          homepage    = "https://swaywm.org";
          changelog   = "https://github.com/swaywm/sway/releases/tag/${version}";
          license     = licenses.mit;
          platforms   = platforms.linux;
          maintainers = with maintainers; [ primeos synthetica ma27 ];
        };
      };
    
    overlay = final: prev: {
      sway-borders = self.packages.x86_64-linux.sway-border;
    };
    
  });
}
