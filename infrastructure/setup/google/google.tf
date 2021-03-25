# variables
variable name {}
variable config {}
variable port {}

variable zone {
  default = "europe-west4-b"
}

variable GOOGLE_KEY_LOCATION {
  type = string
}

variable key_name {
  default = "terraform2"
}

variable setup {
  default = ["sudo yum --disablerepo=rhui-rhel-server-rhui-rhscl-7-source-rpms install ansible -y"]
}

variable image {
  default = "rhel-cloud/rhel-7"
}
variable connection {
  default = {
    type = "ssh",
    user = "sebastiannicolajsen"
  }
}

resource "google_compute_instance" "db" {
  name         = "${var.name}-db"
  machine_type = "n1-standard-1" # NOT FREE
  zone         = var.zone
  # host         = "${var.name}-host"
  tags         = ["ssh", "http"]

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name

    access_config {
    }
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  # transfer file:
  provisioner "file" {
    source      = var.config.source
    destination = var.config.destination

    connection {
      type = var.connection.type
      host = google_compute_instance.db.network_interface[0].access_config[0].nat_ip
      private_key = file(var.GOOGLE_KEY_LOCATION)
      user = var.connection.user
    }
  }

  # execute setup:
  provisioner "remote-exec" {
    inline = concat(var.setup, var.config.remote_setup, var.config.remote_exec_db, var.config.remote_start)

    connection {
      type = var.connection.type
      host = google_compute_instance.db.network_interface[0].access_config[0].nat_ip
      private_key = file(var.GOOGLE_KEY_LOCATION)
      user = var.connection.user
    }
  }
}


resource "google_compute_instance" "api" {
  name         = "${var.name}-api"
  machine_type = "n1-standard-1" # NOT FREE
  zone         = var.zone
  tags         = ["ssh", "http"]

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name
    access_config {
    }
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  # transfer file:
  provisioner "file" {
    source      = var.config.source
    destination = var.config.destination

    connection {
      type = var.connection.type
      host = google_compute_instance.api.network_interface[0].access_config[0].nat_ip
      private_key = file(var.GOOGLE_KEY_LOCATION)
      user = var.connection.user
    }
  }

  # execute setup:
  provisioner "remote-exec" {
    inline = concat(["export DB=${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}:${var.port}"],var.setup, var.config.remote_setup, var.config.remote_exec_api, var.config.remote_start)

    connection {
      type = var.connection.type
      host = google_compute_instance.api.network_interface[0].access_config[0].nat_ip
      private_key = file(var.GOOGLE_KEY_LOCATION)
      user = var.connection.user
    }
  }
}

output "endpoint" {
  value = "${google_compute_instance.api.network_interface.0.access_config.0.nat_ip}:${var.port}"
}

output "database" {
  value = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}:${var.port}"
}
