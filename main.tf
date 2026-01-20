provider "google" {
  project = var.project_id
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

# sieć
resource "google_compute_network" "vpc" {
  name = "devops-vpc"
}

# firewall
resource "google_compute_firewall" "fw" {
  name    = "allow-ssh-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VM
resource "google_compute_instance" "vm" {
  name         = "devops-vm"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {}
  }

  metadata = {
    ssh-keys = "devops:${file("~/.ssh/id_ed25519.pub")}"
  }
}

