{
  description = "A template for microcontroller projects written in Zig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Development happens on a Linux machine the board plugs into, on either amd64 or arm64.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # MicroZig 0.15.1 needs Zig 0.15.x, so the pinned series is used instead of the default zig package.
              zig_0_15

              # Build and coverage tools
              gnumake
              kcov

              # Flashing and the serial console
              picotool
              picocom

              # uv manages the Python tools (pre-commit) through
              # pyproject.toml.
              uv
            ];
          };
        }
      );
    };
}
