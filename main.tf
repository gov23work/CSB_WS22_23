provider "google" {
  project = "csbws2223"
  region = "europe-west3"
  zone = "europe-west3-c"
}

/*resource "google_compute_address" "static" {
  name = "ipv4-address"
}*/

#####################################################
resource "google_compute_instance" "prometheus" {
  name = "prometheus"
  machine_type = "e2-medium"
  tags = ["http-server","https-server","prometheus"]
  boot_disk {
    initialize_params {
	  size = 40
      image = "ubuntu-2204-jammy-v20221101a"
    }
  }
  metadata_startup_script = file("startup_sut.sh")


  network_interface {
    network = "default"
    access_config {
    }
  }
}

################################################

resource "google_compute_instance" "client" {
  count = 7
  name = "prometheus-client${count.index + 1}"
  machine_type = "e2-medium"
  tags = ["http-server","https-server","prometheus"]
  boot_disk {
    initialize_params {
	  size = 40
      image = "ubuntu-2204-jammy-v20221101a"
    }
  }
  metadata_startup_script = file("startup_client.sh")


  network_interface {
    network = "default"
    access_config {
    }
  }
}
#avg(avg_over_time(scrape_duration_seconds{instance!="localhost:9090"}[2m]))
#rate(prometheus_tsdb_head_samples_appended_total[2m])
#avg(100*avg_over_time(up{job="prometheus"}[1m]))