{
  description = "Autogenerate docs from a template and docstrings.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/e158d9ed9b51c98974c5e66e1ba1c9e0255fecaa";
  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forAll (pkgs: with pkgs; rec {
        gendocs = sbcl.buildASDFSystem {
          pname = "gendocs";
          version = "0.0.0";
          src = (lib.cleanSourceWith { src = self; filter = p: _: !(lib.hasSuffix ".fasl" p || lib.hasPrefix ".#" (baseNameOf p)); });
          systems = [ "gendocs" ];
          lispLibs = [ sbclPackages.docparser sbclPackages.alexandria ];
          meta = { description = "Autogenerate docs from a template and docstrings."; homepage = "https://github.com/equwal/gendocs"; license = lib.licenses.gpl3Only; };
        };
        default = gendocs;
        # an SBCL with this system (and its dependencies) preloaded: `nix run .#sbcl`
        sbcl-with = sbcl.withPackages (ps: [ gendocs ]);
      });
      apps = forAll (pkgs: {
        sbcl = { type = "app"; program = "${self.packages.${pkgs.system}.sbcl-with}/bin/sbcl"; };
      });
    };
}
