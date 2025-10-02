mod lib;
mod binaries;

#[tokio::main]
async fn main() {
    println!("Hello from rust_nix_tech!");
    binaries::network::fetch_example().await;
    binaries::db::dummy_db();
}
