terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}


provider "docker" {}
provider "local" {}

variable "host_ip" {
  type        = string
  description = "Host IP (LAN or Tailscale). Example: 100.82.170.21"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}

locals {
  nginx_url = "http://${var.host_ip}:8000/"
}



resource "local_file" "nginx_url" {
  filename = "${path.module}/nginx-url.html"
  content  = <<EOT
<html>
  <body>
    <p>a Nginx is running here: 
      <a href="${local.nginx_url}" target="_blank">${local.nginx_url}</a>
    </p>
  </body>
</html>
EOT
}

output "nginx_url" {
  value = local.nginx_url
}


