{
  description = "Rust + Nix full example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Define the Rust toolchain we want to use
        rustToolchain = pkgs.rust-bin.nightly.latest.default.override {
          extensions = [ "rust-src" ];
          targets = [
            "x86_64-unknown-linux-musl"
            "aarch64-unknown-linux-gnu"
            "x86_64-pc-windows-gnu"
          ];
        };

        # Helper to build the package for a specific target
        buildForTarget = target: 
          let
            # Determine the correct cross-compilation package set
            crossPkgs = if target == "x86_64-unknown-linux-gnu" then pkgs 
              else if target == "x86_64-unknown-linux-musl" then pkgs.pkgsStatic
              else if target == "aarch64-unknown-linux-gnu" then pkgs.pkgsCross.aarch64-multiplatform
              else if target == "x86_64-pc-windows-gnu" then pkgs.pkgsCross.mingwW64
              else pkgs; # Fallback, might fail if not handled
          in
          (crossPkgs.makeRustPlatform {
            cargo = rustToolchain;
            rustc = rustToolchain;
          }).buildRustPackage {
            pname = "rust_nix_tech";
            version = "0.1.0";
            src = ./.;
            cargoLock = {
              lockFile = ./Cargo.lock;
            };
            # We don't need to specify buildTargets here for single-target builds,
            # but we do need to ensure the toolchain supports them.
          };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            rustToolchain
            pkgs.openssl
            pkgs.pkg-config
            pkgs.git
            pkgs.docker
          ];

          shellHook = ''
            echo "Dev shell ready: Rust nightly (via overlay), multi-target supported."
            echo "Available targets:"
            rustc --print target-list | grep -E "musl|windows|aarch64"
          '';
        };

        packages = {
          default = buildForTarget "x86_64-unknown-linux-gnu"; # Default to host (assuming linux)
          
          # Cross-compilation outputs
          musl = buildForTarget "x86_64-unknown-linux-musl";
          aarch64 = buildForTarget "aarch64-unknown-linux-gnu";
          windows = buildForTarget "x86_64-pc-windows-gnu";
        };
      }
    );
}
