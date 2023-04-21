variable "InstanceProfile" {
   default = "BasicRole"
   }

variable "s3bucket" {
   default = "mydemo.resourceonline.org"
   }

variable "ami" {
   default = "ami-07ec38a03db614220"
   }

variable "keypair" {
   default = "tony-keypair"
   }

variable "instance_type" {
   default = "t2.micro"
   }

variable "region" {
   default = "us-west-2"
   }

variable "hostname" {
   default = "webdev1"
   }

variable "domain" {
   default = "resourceonline.org"
   }

variable "boot_volume_size" {
   default = 16
   }

variable "zone_2a" {
   default = "us-west-2a"
   }

variable "zone_2b" {
   default = "us-west-2b"
   }

variable "zone_2c" {
   default = "us-west-2c"
   }

variable "environment_tag" {
   default = "DEV"
   }

variable "data_vol_size" {
   default = 8
   }

variable "log_vol_size" {
   default = 8
   }
