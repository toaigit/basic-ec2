terraform {
  backend "s3" {
    bucket = "tffiles.resourceonline.org"
    key    = "ps/vm/webdev1"
    region = "us-west-2"
  }
}
