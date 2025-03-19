terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.25.0"
    }
  }
}

provider "google" {
  alias       = "mitsui-id-net"
  project     = var.project-id-net
  region      = var.region-id
  zone        = "asia-southeast2-a"
  credentials = var.id-net-creds
}

provider "google" {
  alias       = "mitsui-id-core"
  project     = var.project-id-core
  region      = var.region-id
  zone        = "asia-southeast2-a"
  credentials = var.id-core-creds
}

provider "google-beta" {
  alias       = "mitsui-id-core"
  project     = var.project-id-core
  region      = var.region-id
  zone        = "asia-southeast2-a"
  credentials = var.id-core-creds
}

provider "google" {
  alias       = "mitsui-jp-net"
  project     = var.project-jp-net
  region      = var.region-jp
  zone        = "asia-northeast2-a"
  credentials = var.jp-net-creds
}
