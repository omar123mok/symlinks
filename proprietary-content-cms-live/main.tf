locals {
  environment     = "live"
  workload        = "proprietary-content-cms"
  alias           = "${local.workload}-${local.environment}"
  tags            = merge(local.common-tags, { env = "${local.environment}" })
  cidr            = "10.2.73.0/24"
  secondary-cidr  = local.prop-pub-cms-live-secondary-cidr
  azs             = ["use1-az1", "use1-az2", "use1-az5"]
  lb-subnets      = ["10.2.73.0/26", "10.2.73.64/26", "10.2.73.128/26"]
  private-subnets = ["100.68.16.0/25", "100.68.16.128/25", "100.68.17.0/25"]
  data-subnets    = ["100.68.17.128/27", "100.68.17.160/27", "100.68.17.192/27"]
}


module "iam" {
  source       = "../../modules/iam"
  alias        = local.alias
  tags         = local.tags
  jenkins-role = true
  #create-service-linked-roles = true
  ec2-ssm-role = true
  #developers-role             = true
  app-support-role = true
  custodian-role   = true
  #allow-manual-parameters     = true
  cloudability-eid = "46a16abf-8b2f-49df-84d2-0a54cc877d6d"
  #cloudability-eid            = "89875fe9-b34d-425e-9381-aa9b2618fc2c"
  #readonly-accessible-kms     = [local.atlantis-iam-user-kms-key-id]
}

module "config" {
  source = "../../modules/config"
  tags   = local.tags
}

module "s3" {
  source = "../../modules/s3"
}

module "vpc" {
  source = "../../modules/vpc"

  alias                    = local.alias
  suffix                   = "use1-${local.workload}-${local.environment}-a"
  cidr                     = local.cidr
  secondary-cidr           = local.secondary-cidr
  enable-datasync-endpoint = true
  enable-send-s3-flowlogs  = false

  # See Services > Resource Access Manager > Your AZ ID. Avoid use1-az3 which doesn't have sufficient capacity
  azs  = local.azs #["use1-az1", "use1-az2"]
  tags = local.tags

  lb-subnets      = local.lb-subnets
  private-subnets = local.private-subnets
  data-subnets    = local.data-subnets

  private-route-tgw-cidrs = [
    "0.0.0.0/0", # Needed for anything to reach Internet. Send everything to TGW.
    #"10.80.0.0/16",                  # EDC live
    #"10.84.0.0/16",                  # SDC EDN live
    # "10.85.0.0/16",                # SDC EDN live
    # "172.29.0.0/16",               # PDC VLAB
    # "172.27.0.0/19",               # sample On-Prem
    # local.ss-secondary-cidr,         # Shared services
    # local.ss-secondary-cidr-b,     # Shared services
    local.network-secondary-cidr, # Allow traffic to Zscaler
  ]
  data-route-tgw-cidrs = [
    # "10.84.0.0/16",                # SDC EDN live
    # "10.85.0.0/16",                # SDC EDN live
    # "172.29.0.0/16",               # PDC VLAB
    # "172.27.0.0/19",               # sample On-Prem
    #local.ss-secondary-cidr,        # Shared services
    #local.ss-secondary-cidr-b,      # Shared services
    #local.ss-secondary-cidr,    # Shared services live
    #local.network-secondary-cidr,    # Allow traffic to Zscaler
  ]

  lb-inbound-nacls = [
    # Deny SSH
    { number = 100, allow = false, from = 22, to = 22, protocol = 6, cidr = "0.0.0.0/0" },
    # Deny RDP
    { number = 101, allow = false, from = 3389, to = 3389, protocol = 6, cidr = "0.0.0.0/0" },
    # Intranet HTTPS traffic. Allows internal testing from NAT on prem. We will need one for Zepheira.
    { number = 200, allow = true, from = 443, to = 443, protocol = 6, cidr = "140.234.253.9/32" },
    { number = 205, allow = true, from = 443, to = 443, protocol = 6, cidr = "140.234.254.9/32" },
    { number = 206, allow = true, from = 443, to = 443, protocol = 6, cidr = "140.234.251.9/32" },
    # Allow Github IPs HTTPS traffic.
    #{ number = 130, allow = true, from = 443, to = 443, protocol = 6, cidr = "192.30.252.0/22" },
    #{ number = 140, allow = true, from = 443, to = 443, protocol = 6, cidr = "185.199.108.0/22" },
    #{ number = 150, allow = true, from = 443, to = 443, protocol = 6, cidr = "140.82.112.0/20" },
    # VDI live traffic
    #{ number = 630, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.vdi-live-secondary-cidr },
    # Traffic from Zscaler connectors. Needed to test application from laptop.
    #{ number = 300, allow = true, from = 443, to = 443, protocol = 6, cidr = local.network-secondary-cidr },
    # NAT gateway traffic. Traffic from LZ that goes into lb subnets.
    { number = 500, allow = true, from = 443, to = 443, protocol = 6, cidr = "3.218.133.15/32" },
    { number = 510, allow = true, from = 443, to = 443, protocol = 6, cidr = "3.215.83.36/32" },
    { number = 520, allow = true, from = 443, to = 443, protocol = 6, cidr = "3.215.10.228/32" },
    # Temporarily allow port 80 for testing ALB redirects
    { number = 530, allow = true, from = 80, to = 80, protocol = 6, cidr = "3.218.133.15/32" },
    { number = 540, allow = true, from = 80, to = 80, protocol = 6, cidr = "3.215.83.36/32" },
    { number = 550, allow = true, from = 80, to = 80, protocol = 6, cidr = "3.215.10.228/32" },
    # Shared services live traffic
    { number = 610, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr },
    { number = 620, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr-b },
    # Return traffic from private subnets for health checks
    { number = 600, allow = true, from = 0, to = 0, protocol = -1, cidr = local.secondary-cidr },
  ]
  lb-outbound-nacls = [
    # Return traffic to Intranet. Allows internal testing from NAT on prem. We will need one for Zepheira
    { number = 100, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "140.234.253.9/32" },
    { number = 105, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "140.234.254.9/32" },
    { number = 106, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "140.234.251.9/32" },
    # Allow Github IPs HTTPS traffic
    # { number = 130, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "192.30.252.0/22" },
    # { number = 140, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "185.199.108.0/22" },
    # { number = 150, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "140.82.112.0/20" },
    # Return traffic to Zscaler connectors
    #{ number = 200, allow = true, from = 1024, to = 65535, protocol = 6, cidr = local.network-secondary-cidr },
    # Return traffic from NAT gateways
    { number = 500, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "3.218.133.15/32" },
    { number = 510, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "3.215.83.36/32" },
    { number = 520, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "3.215.10.228/32" },
    # Panorama Public ips return traffic
    { number = 530, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "52.0.209.159/32" },
    { number = 540, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "34.237.10.6/32" },
    { number = 550, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "34.194.117.173/32" },
    { number = 560, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "34.226.102.10/32" },
    # VDI live traffic
    #{ number = 630, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.vdi-live-secondary-cidr },
    # Return traffic from private subnets
    { number = 400, allow = true, from = 0, to = 0, protocol = -1, cidr = local.secondary-cidr },
  ]

  private-inbound-nacls = [
    # Deny SSH
    { number = 100, allow = false, from = 22, to = 22, protocol = 6, cidr = "0.0.0.0/0" },
    # Deny RDP
    { number = 101, allow = false, from = 3389, to = 3389, protocol = 6, cidr = "0.0.0.0/0" },
    # Inbound/outbound from data subnets
    { number = 200, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.secondary-cidr },
    # Intranet traffic and return traffic from on-premise DNS servers
    { number = 300, allow = true, from = 0, to = 0, protocol = "-1", cidr = "10.0.0.0/8" },
    # Intranet traffic. This is for all remote sites(GOBI, etc) NOT EIS and Corporate. 
    #{ number = 500, allow = true, from = 0, to = 0, protocol = "-1", cidr = "172.16.0.0/12" },
    # Traffic from Zscaler connectors
    #{ number = 600, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.network-secondary-cidr },
    # Shared services live traffic
    { number = 610, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr },
    { number = 620, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr-b },
    # VDI live traffic
    #{ number = 630, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.vdi-live-secondary-cidr },
    # Return traffic from Internet for DNS (TCP)
    { number = 800, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "0.0.0.0/0" },
    # Return traffic from Internet for DNS (UDP)
    { number = 810, allow = true, from = 1024, to = 65535, protocol = 17, cidr = "0.0.0.0/0" },
  ]
  private-outbound-nacls = [
    # Allow all traffic to data subnets
    { number = 100, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.secondary-cidr },
    # Intranet traffic (includes DNS requests to on-premise)
    { number = 200, allow = true, from = 0, to = 0, protocol = "-1", cidr = "10.0.0.0/8" },
    # Intranet traffic. This is for all remote sites(GOBI, etc) NOT EIS and Corporate.
    #{ number = 500, allow = true, from = 0, to = 0, protocol = "-1", cidr = "172.16.0.0/12" },
    # Return traffic to Zscaler connectors
    #{ number = 600, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.network-secondary-cidr },
    # Shared services live traffic
    { number = 610, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr },
    { number = 620, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr-b },
    # VDI live traffic
    #{ number = 630, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.vdi-live-secondary-cidr },
    # TODO: Allow outbound HTTP. yum uses http
    { number = 800, allow = true, from = 80, to = 80, protocol = 6, cidr = "0.0.0.0/0" },
    # TODO: Allow outbound HTTPS
    { number = 810, allow = true, from = 443, to = 443, protocol = 6, cidr = "0.0.0.0/0" },
    # Allow outbound DNS (TCP)
    { number = 820, allow = true, from = 53, to = 53, protocol = 6, cidr = "0.0.0.0/0" },
    # Allow outbound DNS (UDP)
    { number = 830, allow = true, from = 53, to = 53, protocol = 17, cidr = "0.0.0.0/0" },
  ]

  data-inbound-nacls = [
    # Deny SSH
    { number = 100, allow = false, from = 22, to = 22, protocol = 6, cidr = "0.0.0.0/0" },
    # Deny RDP
    { number = 110, allow = false, from = 3389, to = 3389, protocol = 6, cidr = "0.0.0.0/0" },
    # Deny public subnets
    { number = 120, allow = false, from = 0, to = 0, protocol = "-1", cidr = "10.2.0.0/16" },
    # Inbound/outbound from private subnets
    { number = 200, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.secondary-cidr },
    # Allow all traffic from Intranet (includes DNS return traffic from on-premise)
    #{ number = 500, allow = true, from = 0, to = 0, protocol = "-1", cidr = "10.0.0.0/8" },
    #  Intranet traffic. This is for all remote sites(GOBI, etc) NOT EIS and Corporate.
    #{ number = 510, allow = true, from = 0, to = 0, protocol = "-1", cidr = "172.16.0.0/12" },
    # Traffic from Zscaler connectors
    #{ number = 600, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.network-secondary-cidr },
    # Shared services live traffic
    { number = 610, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr },
    { number = 620, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr-b },
    # Return traffic from Internet for DNS (TCP)
    { number = 800, allow = true, from = 1024, to = 65535, protocol = 6, cidr = "0.0.0.0/0" },
    # Return traffic from Internet for DNS (UDP)
    { number = 810, allow = true, from = 1024, to = 65535, protocol = 17, cidr = "0.0.0.0/0" },
  ]
  data-outbound-nacls = [
    # Deny traffic to public subnets
    { number = 100, allow = false, from = 0, to = 0, protocol = "-1", cidr = "10.2.0.0/16" },
    # Allow all traffic to private subnets
    { number = 200, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.secondary-cidr },
    # Intranet traffic (includes DNS requests to on-premise)
    #{ number = 300, allow = true, from = 0, to = 0, protocol = "-1", cidr = "10.0.0.0/8" },
    # Intranet traffic
    #{ number = 400, allow = true, from = 0, to = 0, protocol = "-1", cidr = "172.16.0.0/12" },
    # Return traffic to Zscaler connectors
    #{ number = 600, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.network-secondary-cidr },
    # Shared services traffic
    { number = 610, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr },
    { number = 620, allow = true, from = 0, to = 0, protocol = "-1", cidr = local.ss-secondary-cidr-b },
    # Allow outbound to Internet (TCP)
    { number = 820, allow = true, from = 53, to = 53, protocol = 6, cidr = "0.0.0.0/0" },
    # Allow outbound to Internet (UDP)
    { number = 830, allow = true, from = 53, to = 53, protocol = 17, cidr = "0.0.0.0/0" },
  ]

}

module "rr-associations" {
  source = "../../modules/rr-associations"
  vpc-id = module.vpc.vpc-id
}

module "route53-zones" {
  source = "../../modules/route53-zones"
  vpc-id = module.vpc.vpc-id
  tags   = local.tags
  public-zones = [
    { zone : "${local.workload}-${local.environment}.eislz.com", sub-zones : [] }
  ]
}

#module "subnet-groups" {
#  source                  = "../../modules/subnet-groups"
#  data-subnets            = module.vpc.data-subnets
#  tags                    = local.tags
#  create-dms-subnet-group = false
#}

module "session-manager-defaults" {
  source = "../../modules/session-manager-defaults"
  alias  = local.alias
  tags   = local.tags
  depends_on = [
    module.vpc
  ]
}
