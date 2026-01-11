{
  description = "A template Python package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      revision = self.shortRev or self.dirtyShortRev or "unknown";
    in {
      packages.default = pkgs.python3Packages.buildPythonPackage {
        pname = "template";
        version = revision;
        src = ./.;

        format = "pyproject";

        nativeBuildInputs = with pkgs.python3Packages; [
          setuptools
          wheel
        ];

        propagatedBuildInputs = with pkgs.python3Packages; [
        ];

        checkInputs = with pkgs.python3Packages; [
          pytest
        ];

        checkPhase = ''
          ${pkgs.python3Packages.pytest}/bin/pytest
        '';

        meta = with pkgs.lib; {
          description = "A template Python package";
          license = licenses.agpl3Only;
        };
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.default ];

        buildInputs = with pkgs; [
          python3
          python3Packages.pytest
        ];
      };
    });
}
