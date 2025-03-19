
variable "region-id" {
  description = "Indonesia Region"
  type        = string
  default     = "asia-southeast2"
}

variable "region-jp" {
  description = "Japan Region"
  type        = string
  default     = "asia-northeast2"
}

variable "project-id-net" {
  description = "ID net Project"
  type        = string
  default     = "mitsui-id-network-defaroyan"
}

variable "project-id-core" {
  description = "id core project"
  type        = string
  default     = "mitsui-id-core-defaroyan"
}


variable "project-jp-net" {
  description = "jp net project"
  type        = string
  default     = "mitsui-jp-network-defaroyan"
}

variable "jp-net-creds" {
  type        = string
  sensitive   = true
  description = "Google Cloud service account credentials"
  default     = "creds/jp-net.json"
}

variable "id-net-creds" {
  type        = string
  sensitive   = true
  description = "Google Cloud service account credentials"
  default     = "creds/id-net.json"
}

variable "id-core-creds" {
  type        = string
  sensitive   = true
  description = "Google Cloud service account credentials"
  default     = "creds/id-core.json"
}