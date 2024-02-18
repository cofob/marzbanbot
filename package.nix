{ lib
, python3
, python3Packages
}:

python3.pkgs.buildPythonPackage rec {
  pname = "marzbanbot";
  version = "0.1.0";
  pyproject = true;

  src = ./.;

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    aiogram
    aiohttp
  ];
}