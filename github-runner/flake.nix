{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        packages = {
          githubRunner = dockerTools.buildLayeredImage {
            name = "github-runner";
            tag = "latest";
            contents = [
              coreutils
              github-runner
              nix
            ];
            config = {
              entrypoint = [ "Runner.Listener" ];
            };
          };
        };
      }
    );
}
