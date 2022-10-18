with import
  (fetchTarball "https://github.com/NixOS/nixpkgs/archive/21.11.tar.gz")
{ };

let
  paths = with pkgs; [
    cmake
    gcc
    git
    gnumake
    shellcheck
    zlib
  ];

  env = pkgs.buildEnv {
    name = "heroku-buildpack-velory-client-env";
    paths = paths;
    extraOutputsToInstall = [ "bin" ];
  };

  pathEnv = builtins.getEnv "PATH";
in
pkgs.mkShell {
  name = "heroku-buildpack-velory-client";
  phases = lib.optional stdenv.isLinux [ "unpackPhase" ] ++ [ "noPhase" ];
  noPhase = "mkdir -p $out";

  buildInputs = paths;

  shellHook = ''
    PATH=${env}/bin:${pathEnv}
  '';
}
