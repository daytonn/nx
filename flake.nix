{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      # Enable unfree packages
      pkgsUnfree = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      devShells.x86_64-linux.default =
        pkgs.mkShell
        {
          buildInputs = [
            pkgs.shellcheck
            pkgsUnfree.claude-code
          ];
          # shellHook = '' '';
        };
  };
}
