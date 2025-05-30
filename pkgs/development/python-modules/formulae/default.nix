{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  numpy,
  pandas,
  scipy,
}:

buildPythonPackage rec {
  pname = "formulae";
  version = "0.5.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = "formulae";
    tag = version;
    hash = "sha256-SSyQa7soIp+wSXX5wek9LG95q7J7K34mztzx01lPiWo=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  # use assertions of form `assert pytest.approx(...)`, which is now disallowed:
  disabledTests = [
    "test_basic"
    "test_degree"
  ];
  pythonImportsCheck = [
    "formulae"
    "formulae.matrices"
  ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/formulae";
    description = "Formulas for mixed-effects models in Python";
    changelog = "https://github.com/bambinos/formulae/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
