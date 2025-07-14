variable "REGISTRY" { default = "docker.io" }
variable "OWNER" { default = "khuedoan" }
variable "TAG" { default = "latest" }

target "default" {
  matrix = {
    image = [
      "github-runner",
      "netshoot",
      "radicle-explorer",
      "radicle-server",
      "woodpecker-nix-develop"
    ]
  }
  name = image
  context = image
  tags = [
    "${REGISTRY}/${OWNER}/${image}:${TAG}",
  ]
  platforms = ["linux/amd64", "linux/arm64"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/khuedoan/container-images"
    "org.opencontainers.image.author" = "mail@khuedoan.com"
  }
}
