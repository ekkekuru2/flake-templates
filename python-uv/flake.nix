{
  description = "Python with uv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          # numpyは高速化のために共有ライブラリを使いたいのだが、NixOSでは設計上そのままだとそれができない
          # 事前にNixOSのconfiguration.nixでnix-ldを有効化した上で、LD_LIBRARY_PATHを設定してあげる。
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
            with pkgs;
            [
              # glibc
              # glibc.dev
              # glib
              # libgcc
              stdenv.cc.cc
              zlib
            ]
          );
          buildInputs = [
            pkgs.python314
            pkgs.uv
          ];
          shellHook = ''
            echo "uv version: $(uv --version)"
            echo "python version: $(python --version)"
          '';
        };
      });
}
