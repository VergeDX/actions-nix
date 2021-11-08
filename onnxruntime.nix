{ stdenv, fetchgit, python3, cmake, zlib, python3Packages, substituteAll, lib, ... }:
let
  # https://github.com/NixOS/nixpkgs/issues/138338
  fixed_onnx = python3Packages.onnx.override {
    nbval = python3Packages.nbval.overrideAttrs (old: {
      pytestFlagsArray = old.pytestFlagsArray ++ [
        "--ignore=tests/test_ignore.py"
      ];
    });
  };
in
stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "1.9.1";

  src = fetchgit {
    url = "https://github.com/microsoft/${pname}";
    rev = "v${version}";
    sha256 = "sha256-6D8QU7IfDcR1/5UZ7ja9MiK2BDt+esr0lpAuvtPtQsg=";
  };

  pybind11_src = fetchgit {
    url = "https://github.com/pybind/pybind11";
    rev = "v2.6.2";
    sha256 = "sha256-/uKmVntR06NGKWZHDj/ky3nNdZJcMQApLusJytVlStM=";
  };

  dontUseCmakeConfigure = true;
  buildPhase = ''
    patchShebangs ./build.sh
    ./build.sh \
      --skip_submodule_sync \
      --enable_pybind \
      --build_wheel \
      --parallel \
  '';

  nativeBuildInputs = [ python3 cmake ]
    ++ (with python3Packages; [ numpy pybind11 ])
    ++ lib.singleton fixed_onnx;
  dontUsePytestCheck = true;
  buildInputs = [ zlib ];

  patches = [
    (substituteAll {
      src = ./no_fetch_pybind11.patch;
      pybind11 = pybind11_src;
    })
  ];
}
