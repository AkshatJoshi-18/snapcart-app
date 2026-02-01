variable "REGISTRY" {
  default = "docker.io/akshat8630"
}

variable "VERSION" {
  default = "latest"
}

variable "GITHUB_SHA" {
  default = ""
}

variable "CI" {
  default = "false"
}

variable "PLATFORMS" {
  default = null
}

group "default" {
  targets = ["frontend", "backend"]
}

target "_common" {
  platforms = PLATFORMS
  labels = {
    "org.opencontainers.image.source" = "https://github.com/AkshatJoshi-18/snapcart-app"
    "org.opencontainers.image.revision" = "${GITHUB_SHA}"
  }
}

target "frontend" {
  inherits = ["_common"]
  context = "./snapcart-frontend"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/snapcart-frontend:${VERSION}",
    "${REGISTRY}/snapcart-frontend:latest"
  ]

  cache-from = CI == "true" ? [
    "type=gha,scope=frontend",
    "type=registry,ref=${REGISTRY}/frontend:buildcache"
  ] : [
    "type=local,src=.buildx-cache/frontend"
  ]
  
  cache-to = CI == "true" ? [
    "type=gha,scope=frontend,mode=max",
    "type=registry,ref=${REGISTRY}/frontend:buildcache,mode=max"
  ] : [
    "type=local,dest=.buildx-cache/frontend,mode=max"
  ]

  args = {
    NODE_ENV = "production"
  }
}

target "backend" {
  inherits = ["_common"]
  context = "./snapcart-backend"
  dockerfile = "Dockerfile"
  tags = [
    "${REGISTRY}/snapcart-backend:${VERSION}",
    "${REGISTRY}/snapcart-backend:latest"
  ]

  cache-from = CI == "true" ? [
    "type=gha,scope=backend",
    "type=registry,ref=${REGISTRY}/backend:buildcache"
  ] : [
    "type=local,src=.buildx-cache/backend"
  ]

  cache-to = CI == "true" ? [
    "type=gha,scope=backend,mode=max",
    "type=registry,ref=${REGISTRY}/backend:buildcache,mode=max"
  ] : [
    "type=local,dest=.buildx-cache/backend,mode=max"
  ]
}