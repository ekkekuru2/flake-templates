{
  # thanks: https://scrapbox.io/tani-note/Nix%E3%81%AB%E3%82%88%E3%82%8B%E5%86%8D%E7%8F%BE%E6%80%A7%E3%81%AE%E3%81%82%E3%82%8BTypst%E5%9F%B7%E7%AD%86%E7%92%B0%E5%A2%83
  # フォントまでNixで管理することで再現性を高める
  description = "Typst";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fonts = with pkgs; [
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
        font-path = builtins.concatStringsSep ":" fonts;

        # $は普通に使うとNixの文字列展開になってしまうので、''でエスケープ
        typst-compile = pkgs.writeShellScriptBin "compile" ''
          ${pkgs.typst}/bin/typst compile --font-path ${font-path} --ignore-system-fonts $1 ''${1%.typ}.pdf
        '';
        typst-fonts = pkgs.writeShellScriptBin "fonts" ''
          ${pkgs.typst}/bin/typst fonts --font-path ${font-path} --ignore-system-fonts
        '';
      in
      {
        apps = {
          compile = {
            type = "app";
            program = "${typst-compile}/bin/compile";
          };
          fonts = {
            type = "app";
            program = "${typst-fonts}/bin/fonts";
          };
        };
      }
    );
}
