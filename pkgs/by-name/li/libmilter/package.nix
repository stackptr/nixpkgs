{
  lib,
  stdenv,
  fetchurl,
  m4,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "libmilter";
  version = "8.18.1";

  src = fetchurl {
    url = "ftp://ftp.sendmail.org/pub/sendmail/sendmail.${version}.tar.gz";
    sha256 = "sha256-y/HzCcOOSAb3zz6tJCYPF9H+j7YyVtE+2zzdGgmPB3A=";
  };

  buildPhase = ''
    mkdir -p $out/lib
    cd libmilter
    cat > a.m4 <<EOF
      define(\`confCC', \`$CC')
      define(\`confAR', \`$AR')
      define(\`confEBINDIR', \`$out/libexec')
      define(\`confINCLUDEDIR', \`$out/include')
      define(\`confLIBDIR', \`$out/lib')
      define(\`confMANROOT', \`$out/man/cat')
      define(\`confMANROOTMAN', \`$out/man/man')
      define(\`confMBINDIR', \`$out/sbin')
      define(\`confSBINDIR', \`$out/sbin')
      define(\`confSHAREDLIBDIR', \`$out/lib')
      define(\`confUBINDIR', \`$out/bin')
      define(\`confINCGRP', \`root')
      define(\`confLIBGRP', \`root')
      APPENDDEF(\`confENVDEF', \`-DNETINET6')
    EOF
    export MILTER_SOVER=1
    sh Build -f ./a.m4
  '';

  patches = [
    ./install.patch
    ./sharedlib.patch
    ./darwin.patch
  ];

  nativeBuildInputs = [ m4 ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    fixDarwinDylibNames $out/lib/libmilter.*.1
  '';

  meta = with lib; {
    description = "Sendmail Milter mail filtering API library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.sendmail;
  };
}
