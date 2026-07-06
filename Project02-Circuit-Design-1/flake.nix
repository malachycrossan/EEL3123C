{
  description = "SymPy development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Change to aarch64-darwin if on Apple Silicon
      pkgs = import nixpkgs { inherit system; };

      # Customize your Python packages here
      pythonEnv = pkgs.python3.withPackages (ps: with ps; [
        sympy
        numpy
        scipy
        matplotlib
        # ipython
        # jupyterlab
      ]);
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pythonEnv ];

        shellHook = ''
          echo "SymPy environment ready!"
          # ipython
        '';
      };
    };
}

