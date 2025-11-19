<div align="center">

# Rust + Nix Cross-Compilation Template

**A production-ready template for reproducible Rust development and cross-compilation.**

[![Rust](https://img.shields.io/badge/rust-nightly-orange?style=for-the-badge&logo=rust)](https://www.rust-lang.org/)
[![Nix](https://img.shields.io/badge/Nix-Flakes-blue?style=for-the-badge&logo=nixos)](https://nixos.org/)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#cross-compilation">Cross Compilation</a>
</p>

</div>

---

## Overview

This project demonstrates a robust, hermetic development environment for Rust using **Nix Flakes**. It solves the complexity of setting up cross-compilation toolchains by providing a declarative configuration that works identically across all developer machines and CI/CD pipelines.

The included source code serves as a sample application to verify that the cross-compiled binaries function correctly on their target platforms (Windows, Linux Musl, Aarch64).

## Features

- **Hermetic Toolchain**: Zero global dependencies required. `nix develop` provides the exact Rust version, system libraries, and build tools needed.
- **Cross-Compilation**: Pre-configured targets for Windows (`x86_64-pc-windows-gnu`), Static Linux (`x86_64-unknown-linux-musl`), and ARM64 (`aarch64-unknown-linux-gnu`).
- **Declarative Configuration**: All build logic is contained within `flake.nix`, ensuring reproducibility.
- **CI/CD Ready**: The environment can be cached and reused in CI pipelines to speed up builds.

## Getting Started

### Prerequisites

- [Nix](https://nixos.org/download.html) (with Flakes enabled)

### Development Shell

To enter the reproducible development environment:

```bash
nix develop
```

This shell provides:
- Rust Nightly (via `rust-overlay`)
- `cargo`, `rustc`, `rust-analyzer`
- `pkg-config`, `openssl`
- Cross-compilation toolchains (MinGW, Musl, etc.)

## Cross-Compilation

This template allows you to build artifacts for multiple platforms from a single Linux or macOS machine without installing any additional tools.

| Target Platform | Command | Output Artifact |
|:---|:---|:---|
| **Windows (x64)** | `nix build .#windows` | `./result/bin/rust_nix_tech.exe` |
| **Linux (Static Musl)** | `nix build .#musl` | `./result/bin/rust_nix_tech` |
| **Linux (ARM64)** | `nix build .#aarch64` | `./result/bin/rust_nix_tech` |
| **Host System** | `nix build` | `./result/bin/rust_nix_tech` |

### Verifying Builds

You can verify the file type of the generated binaries using the `file` command:

```bash
file ./result/bin/rust_nix_tech
```

## Project Structure

- `flake.nix`: Defines the Nix development environment and build targets.
- `src/`: Contains the sample Rust application code.

## License

Distributed under the MIT License.
