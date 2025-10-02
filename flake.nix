{
  description = "Rust + Nix full example";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      targets = [
        "x86_64-unknown-linux-musl"
        "aarch64-unknown-linux-gnu"
        "x86_64-pc-windows-gnu"
      ];
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.rustc pkgs.cargo pkgs.rustup pkgs.musl pkgs.gcc
          pkgs.cmake pkgs.pkg-config pkgs.openssl pkgs.zlib pkgs.sqlite
          pkgs.git pkgs.docker
        ];

        shellHook = ''
          export CARGO_HOME=$PWD/.cargo
          export RUSTUP_HOME=$PWD/.rustup
          rustup install nightly || true
          rustup default nightly
          for t in x86_64-unknown-linux-musl aarch64-unknown-linux-gnu x86_64-pc-windows-gnu; do
            rustup target add $t || true
          done
          echo "Dev shell ready: Rust nightly, multi-target, Docker included."
        '';
      };

      packages.x86_64-linux.default = pkgs.rustPlatform.buildRustPackage rec {
        pname = "rust_nix_tech";
        version = "0.1.0";
        src = ./.;
        cargoVendorDir = ./vendor;
        buildTargets = targets;
      };
    };
}
