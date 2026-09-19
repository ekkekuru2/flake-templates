{
  outputs = inputs: {
    templates = {
      python-uv = {
        path = ./python-uv;
        description = "Python with uv templates";
      };
      flake-mkShell = {
          path = ./flake-mkShell;
          description = "Nix flake mkShell template";
      };
      typst = {
        path = ./typst;
        description = "Typst";
      };
      pnpm = {
        path = ./pnpm;
        description = "nodejs, pnpm and typescript";
      };
    };
  };
}
