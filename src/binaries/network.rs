use reqwest;

pub async fn fetch_example() {
    match reqwest::get("https://httpbin.org/get").await {
        Ok(resp) => println!("Fetched: {:?}", resp.status()),
        Err(e) => println!("Error fetching: {}", e),
    }
}
