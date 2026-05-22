variable "ntier_provider" {
  type = object({
    region = optional(string, "ap-south-1")
  })

}

variable "ntier_vpc" {
  type = object({
    cidr_block = optional(string, "10.0.0.0/16")
    subnets_public = list(object({
      cidr_block        = string
      availability_zone = string
      Name              = string
    }))
    subnets_private = list(object({
      cidr_block        = string
      availability_zone = string
      Name              = string
    }))
  })
}

variable "network_name" {
  type    = string
  default = "ntier"
}

variable "ntier_alb" {
  type = object({
    Name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      description = string
      ip_protocol = string
      cidr_ipv4   = string
    }))
    egress = object({
      from_port   = number
      to_port     = number
      ip_protocol = string
      cidr_ipv4   = string
    })
  })

}

variable "ntier_bastion" {
  type = object({
    Name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      description = string
      ip_protocol = string
      cidr_ipv4   = string
    }))
    egress = object({
      from_port   = number
      to_port     = number
      ip_protocol = string
      cidr_ipv4   = string
    })
  })

}

variable "ntier_app" {
  type = object({
    Name        = string
    description = string
    egress = object({
      from_port   = number
      to_port     = number
      ip_protocol = string
      cidr_ipv4   = string
    })
  })

}

variable "ntier_db" {
  type = object({
    Name        = string
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      description = string
      ip_protocol = string
      cidr_ipv4   = optional(string)

    }))
    egress = object({
      from_port   = number
      to_port     = number
      ip_protocol = string
      cidr_ipv4   = string
    })
  })

}

variable "key_pair" {
  type = object({
    name             = string
    public_key_path  = optional(string, "~/.ssh/id_rsa.pub")
    private_key_path = optional(string, "~/.ssh/id_rsa")
  })

}

variable "db_password" {
  type      = string
  sensitive = true

}