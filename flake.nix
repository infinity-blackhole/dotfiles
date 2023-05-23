{
  description = "Shikanime's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-public-keys = [
      "shikanime.cachix.org-1:OrpjVTH6RzYf2R97IqcTWdLRejF6+XbpFNNZJxKG8Ts="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    extra-substituters = [
      "https://shikanime.cachix.org"
      "https://devenv.cachix.org"
    ];
  };

  outputs = { nixpkgs, devenv, ... }@inputs: {
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let pkgs = import nixpkgs { inherit system; }; in {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              pre-commit.hooks = {
                actionlint.enable = true;
                markdownlint.enable = true;
                nixpkgs-fmt.enable = true;
                statix.enable = true;
                deadnix.enable = true;
                prettier.enable = true;
              };
              packages = [
                pkgs.nixpkgs-fmt
                pkgs.gh
                pkgs.glab
                pkgs.ansible
              ];
            }
          ];
        };
      }
    );
  };
}
