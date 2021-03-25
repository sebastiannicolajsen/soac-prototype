variable region {
  default = "europe-west4"
}

# setup VPC

resource "google_compute_network" "vpc" {
  name = "terraform-vpc"
  auto_create_subnetworks = "false"
  routing_mode = "GLOBAL"
}

# setup subnet public and private subnets

resource "google_compute_subnetwork" "public_subnet_1" {
  name = "terraform-public-subnet-1"
  ip_cidr_range = "10.10.1.0/24"
  network = google_compute_network.vpc.name
  region = var.region
}


# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name = "terraform-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = [var.port]
  }
  target_tags = ["http"]
}
# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name = "terraform-fw-allow-https"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = [var.port]
  }
  target_tags = ["https"]
}
# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name = "terraform-fw-allow-ssh"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}
# allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name = "terraform-fw-allow-rdp"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags = ["rdp"]
}
