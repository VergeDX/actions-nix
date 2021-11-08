{ callPackage, python3Packages, fetchgit, ... }:
let onnxruntime = callPackage ./onnxruntime.nix { };
in
python3Packages.buildPythonPackage rec {
  pname = "arknights-mower";
  version = "1.3.8";

  src = fetchgit {
    url = "https://github.com/Konano/${pname}";
    rev = "v${version}";
    sha256 = "sha256-uArB0xXI4y/KEFNqTTNm3QTxsv05tFKQLo/Md/orCc4=";
  };

  propagatedBuildInputs = with python3Packages; [ matplotlib ];
}
