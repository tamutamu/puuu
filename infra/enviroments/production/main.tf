############################
# Network
############################
module "network" {
  source = "../../modules/network"
  app    = var.app
  env    = var.env

  vpc = {
    cidr = "10.1.0.0/16"
  }

  public_subnet_a = {
    cidr = "10.1.1.0/24"
  }

  public_subnet_c = {
    cidr = "10.1.2.0/24"
  }

  private_subnet_a = {
    cidr = "10.1.10.0/24"
  }

  private_subnet_c = {
    cidr = "10.1.20.0/24"
  }
}


############################
# DNS
############################
module "dns" {
  source = "../../modules/dns"
  app    = var.app
  env    = var.env

  domain = var.domain
}


############################
# Frontend ACM
############################
module "frontend_cert" {
  source = "../../modules/cert"
  providers = {
    aws.cert = aws.virginia
  }

  app = var.app
  env = var.env

  domain      = var.domain
  cert_domain = "www.${var.domain}"
}


############################
# Frontend
############################
module "frontend" {
  source = "../../modules/frontend"
  app    = var.app
  env    = var.env

  providers = {
    aws.waf = aws.virginia
  }

  domain          = var.domain
  frontend_domain = "www.${var.domain}"

  aws_acm_certificate            = module.frontend_cert.aws_acm_certificate
  aws_acm_certificate_validation = module.frontend_cert.aws_acm_certificate_validation
}
