use clap::Parser;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;
use std::env;

#[derive(Parser)]
#[command(name = "rust_nix_tech")]
#[command(version = "0.1.0")]
#[command(about = "Cross-Compilation Verification Tool", long_about = None)]
struct Cli {}

fn setup_logging() {
    let subscriber = FmtSubscriber::builder()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(subscriber)
        .expect("setting default subscriber failed");
}

fn main() {
    setup_logging();
    let _cli = Cli::parse();

    info!("Gathering system information...");

    println!("\n);
    println!("OS:           {}", env::consts::OS);
    println!("Family:       {}", env::consts::FAMILY);
    println!("Architecture: {}", env::consts::ARCH);
    println!("DLL Extension: {}", env::consts::DLL_EXTENSION);
    println!("\n");

    info!("Verification complete. If these values match your target platform, cross-compilation was successful.");
}
