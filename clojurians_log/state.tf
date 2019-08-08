terraform {
  backend "s3" {
    bucket = "clojurians-log"
    key = "tfstates/clojurians_log.tfstate"
    # Dummy for S3 compat.
    region = "de-fra-1"
    endpoint = "https://sos-de-fra-1.exo.io"

    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
  }
}
