{ lib, buildPythonPackage, fetchPypi, pyzmq, metakernel, jupyter-client
, setuptools, hatch-vcs, hatchling }:

buildPythonPackage rec {
  pname = "octave_kernel";
  version = "0.35.1";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lsoeITFcC3a1UKWP/A6GrYhafu/ko317611N2Hy01fQ=";
  };
  nativeBuildInputs = [ hatchling hatch-vcs ];
  build-system = [ setuptools ];

  propagatedBuildInputs = [ pyzmq metakernel jupyter-client ];

  doCheck = false; # upstream tests require a running Octave

  meta = {
    description = "A Jupyter kernel for GNU Octave";
    homepage = "https://github.com/Calysto/octave_kernel";
    license = lib.licenses.bsd3;
  };
}
