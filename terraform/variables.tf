variable "region" {
  type        = string
  default     = "us-west-1" 
  description = "The AWS region where resources will be created"
}

variable "domain" {
  type        = string
  default     = "jorgecarrillo.dev" 
  description = "The apex domain of the website"
}

variable "fqdn" {
  type        = string
  default     = "www.jorgecarrillo.dev"
  description = "The Fully Qualified Domain Name of the website"
}

variable "index_document" {
  type        = string
  default     = "index.html"
  description = "Default page S3 will serve when a request is made to the website"
}

variable "error_document" {
  type        = string
  default     = "404.html"
  description = "Default error page S3 will serve in case of a 4XX error"
}

variable "force_destroy" {
  type        = bool
  default     = true
  description = "Delete all objects from the bucket so that the bucket can be destroyed without error"
}