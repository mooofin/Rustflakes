mod core;

use clap::{Parser, Subcommand};
use tracing::{info, error, Level};
use tracing_subscriber::FmtSubscriber;

#[derive(Parser)]
#[command(name = "rust_nix_tech")]
#[command(version = "0.1.0")]
#[command(about = "A demo Rust application with Nix integration", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Fetch recent malware samples from MalwareBazaar
    Fetch {
        /// API Key for MalwareBazaar
        #[arg(short, long)]
        api_key: String,
    },
    /// Interact with the in-memory database
    Db,
}

fn setup_logging() {
    let subscriber = FmtSubscriber::builder()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(subscriber)
        .expect("setting default subscriber failed");
}

#[tokio::main]
async fn main() {
    setup_logging();
    let cli = Cli::parse();

    match &cli.command {
        Commands::Fetch { api_key } => {
            info!("Executing Fetch command...");
            match core::network::fetch_recent_malware(api_key).await {
                Ok(samples) => {
                    info!("Fetched {} samples.", samples.len());
                    // For demo purposes, we also add them to the DB and list them
                    let db = core::db::InMemoryDb::new();
                    db.add_samples(samples);
                    db.list_samples();
                }
                Err(e) => error!("Failed to fetch malware samples: {}", e),
            }
        }
        Commands::Db => {
            info!("Executing DB command...");
            let db = core::db::InMemoryDb::new();
            db.list_samples(); // Will be empty
        }
    }
}
