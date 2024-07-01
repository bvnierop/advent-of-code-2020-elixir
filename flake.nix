{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs.lib) optional optionals;
        pkgs = import nixpkgs { inherit system; };

        erlang = pkgs.erlang_27.overrideAttrs (oldAttrs: rec {
          configureFlags = oldAttrs.configureFlags
                           ++ [ "--with-ssl=${pkgs.lib.getOutput "out" pkgs.openssl}" ]
                           ++ [ "--with-ssl-inc=${pkgs.lib.getDev pkgs.openssl}" ];
        });

        beamPkg = pkgs.beam.packagesWith erlang;

        elixir = beamPkg.elixir_1_17.override {
        };

        in
        with pkgs;
        {
          devShell = pkgs.mkShell {
            buildInputs = [
              erlang
              elixir
              elixir_ls
              glibcLocales
              inotify-tools
              libnotify
            ];
          };
        });
}
