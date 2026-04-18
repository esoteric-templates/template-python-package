{
	description = "Template Python package";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, flake-utils, ... }:
		flake-utils.lib.eachDefaultSystem (system:
		let
			pname = "template";
			pkgs = import nixpkgs { inherit system; };
		in {
			packages.default = pkgs.python3Packages.buildPythonPackage {
				inherit pname;

				version = pkgs.lib.removeSuffix "\n" "${builtins.readFile ./${pname}/assets/version.txt}";
				src = ./.;

				format = "pyproject";

				nativeBuildInputs = with pkgs.python3Packages; [
					setuptools
					wheel
				];

				propagatedBuildInputs = with pkgs.python3Packages; [
				];

				checkInputs = with pkgs.python3Packages; [
					pytestCheckHook
				];

				meta = with pkgs.lib; {
					description = "Template Python package";
					license = licenses.agpl3Only;
				};
			};

			devShells.default = pkgs.mkShell {
				inputsFrom = [ self.packages.${system}.default ];
			};
		});
}
