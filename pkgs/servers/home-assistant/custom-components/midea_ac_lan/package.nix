{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  midea-local,
}:

buildHomeAssistantComponent rec {
  owner = "wuwentao";
  domain = "midea_ac_lan";
  version = "0.6.8";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-y78Leb+XxEpijP7XbmjDGSD2RArfxlSgdtXkeYggxto=";
  };

  dependencies = [ midea-local ];

  meta = with lib; {
    description = "Auto-configure and then control your Midea M-Smart devices (Air conditioner, Fan, Water heater, Washer, etc) via local area network";
    homepage = "https://github.com/wuwentao/midea_ac_lan/";
    changelog = "https://github.com/wuwentao/midea_ac_lan/releases/tag/v${version}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
