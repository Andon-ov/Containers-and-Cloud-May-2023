


terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0.1" # Specify the version you want to use
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name = "nginxdemos/hello"
}

resource "docker_container" "nginx" {
  image = resource.docker_image.nginx.name
  name  = "nginx_hello"

  ports {
    internal = 80
    external = 8080
  }
}






# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "2.16.0" # Specify the version you want to use
#     }
#   }
# }

# provider "docker" {
#   host = "unix:///var/run/docker.sock"
# }

# resource "docker_image" "nginx_hello" {
#   name         = "nginx:latest"
#   keep_locally = false
# }

# resource "docker_container" "nginx_hello_container" {
#   name  = "nginx_hello"
#   image = docker_image.nginx_hello.latest

#   ports {
#     internal = 80
#     external = 8080
#   }
# }
