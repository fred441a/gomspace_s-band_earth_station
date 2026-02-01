{ pkgs ? import <nixpkgs> { } }:

let

  octaveKernel = pkgs.python3Packages.callPackage ./octave_kernel.nix { };

  pythonEnv = pkgs.python3.withPackages

    (ps: [
      ps.numpy
      ps.scipy
      ps.pandas
      ps.sympy
      ps.matplotlib
      ps.jupyterlab
      octaveKernel
    ]);

  octaveEnv = pkgs.octave.withPackages (op: [ op.control op.signal ]);

in pkgs.mkShell {

  buildInputs = [ pythonEnv octaveEnv ];

  shellHook = ''


    echo "========================================="


    echo " JupyterLab available: run 'jupyter lab'"


    echo " Python packages: numpy, scipy, pandas, sympy, matplotlib"


    echo " Octave packages: control, signal"


    echo "========================================="


  '';

}
