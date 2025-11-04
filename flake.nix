{
  description = "A template Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.default = pkgs.python3Packages.buildPythonPackage {
        pname = "template";
        version = "0.1.0";
        src = ./.;

        format = "pyproject";

        nativeBuildInputs = with pkgs.python3Packages; [
          setuptools
          wheel
        ];

        meta = with pkgs.lib; {
          description = "A template Python package";
          license = licenses.agpl3Only;
        };
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python3
          python3Packages.pip
          python3Packages.virtualenv
        ];

        shellHook = ''
          rm -rf .venv/
          python -m venv .venv/

          source .venv/bin/activate

          pip install -r requirements.txt
        '';
      };
    });
}
