locals {

  landing-zone-private-cidr = "100.64.0.0/12"

  # Shared services secondary CIDR
  ss-secondary-cidr = "100.64.32.0/20"

  # Shared services secondary CIDR B
  ss-secondary-cidr-b = "100.67.32.0/20"

  # Shared services DevQA secondary CIDR
  ss-devqa-secondary-cidr = "100.64.48.0/20"

  # Shared services DevQA secondary CIDR B
  ss-devqa-secondary-cidr-b = "100.67.48.0/20"

  # Active Directory secondary CIDR Summary
  ad-secondary-cidr-summary = "100.68.4.0/25"

  # Active Directory secondary CIDR us-east-1
  ad-secondary-cidr = "100.68.4.0/26"

  # Active Directory secondary CIDR eu-west-1
  ad-secondary-cidr-euc1 = "100.68.4.64/26"

  # Content DevQA secondary CIDR
  content-devqa-secondary-cidr = "100.67.16.0/22"

  # Content DevQA Private Summary
  content-devqa-private-summary = "100.67.16.0/23"

  # Content DevQA Data Summary
  content-devqa-data-summary = "100.67.18.0/23"

  # Content Live secondary CIDR
  content-live-secondary-cidr = "100.67.20.0/22"

  # Content Live Private Summary
  content-live-private-summary = "100.67.20.0/23"

  #Content Live Data Summary
  content-live-data-summary = "100.67.22.0/23"

  # Ehost DevQA secondary CIDR
  ehost-devqa-secondary-cidr = "100.66.0.0/17"

  # Devqa cidr
  devqa-app-cidr = "100.79.0.0/16"

  # Ehost Integration secondary CIDR
  ehost-int-secondary-cidr = "100.67.192.0/18"

  # Ehost Live Pi secondary CIDR
  ehost-live-secondary-cidr = "100.65.0.0/16"

  # Ehost Live Pi Data Subnets Summary CIDR
  ehost-live-pi-data-summary-cidr = "100.65.192.0/19"

  # Ehost Live Pi Private 1 CIDR
  ehost-live-pi-private-1-cidr = "100.65.0.0/18"

  # Ehost Live Pi Private 2 CIDR
  ehost-live-pi-private-2-cidr = "100.65.64.0/18"

  # Ehost Live Pi Private 3 CIDR
  ehost-live-pi-private-3-cidr = "100.65.128.0/18"

  # Ehost Live Sigma secondary CIDR
  ehost-live-sigma-secondary-cidr = "100.69.0.0/16"

  # Ehost Live Sigma Data Subnets Summary CIDR
  ehost-live-sigma-data-summary-cidr = "100.69.192.0/19"

  # Ehost Live Sigma Private 1 CIDR
  ehost-live-sigma-private-1-cidr = "100.69.0.0/18"

  # Ehost Live Sigma Private 2 CIDR
  ehost-live-sigma-private-2-cidr = "100.69.64.0/18"

  # Ehost Live Sigma Private 3 CIDR
  ehost-live-sigma-private-3-cidr = "100.69.128.0/18"

  # GOBI DevQA secondary CIDR
  gobi-devqa-secondary-cidr = "100.68.0.0/24"

  # GOBI Integration secondary CIDR
  gobi-int-secondary-cidr = "100.68.2.0/24"

  # GOBI Live secondary CIDR
  gobi-live-secondary-cidr = "100.68.1.0/24"

  # Indexing Pipeline DevQA secondary CIDR
  indexing-pipeline-devqa-secondary-cidr = "100.67.64.0/20"

  # Indexing Pipeline DevQA Private Subnet Summary CIDR
  indexing-pipeline-devqa-private-summary-cidr = "100.67.64.0/21"

  # Indexing Pipeline DevQA Data Subnet Summary CIDR
  indexing-pipeline-devqa-data-summary-cidr = "100.67.72.0/23"

  # Indexing Pipeline Live secondary CIDR
  indexing-pipeline-live-secondary-cidr = "100.67.80.0/21"

  # Indexing Pipeline Live Private Subnet Summary CIDR
  indexing-pipeline-live-private-summary-cidr = "100.67.80.0/22"

  #Indexing Pipeline Live Data Subnet Summary CIDR
  indexing-pipeline-live-data-summary-cidr = "100.67.84.0/24"

  # KG DevQA secondary CIDR
  kg-devqa-secondary-cidr = "100.67.12.0/23"

  # KG DevQA Private Summary CIDR
  kg-devqa-private-cidr = "100.67.12.0/24"

  # KG DevQA Data Summary CIDR
  kg-devqa-data-cidr = "100.67.13.0/24"

  # KG Live secondary CIDR
  kg-live-secondary-cidr = "100.67.14.0/23"

  # KG Live Private Summary CIDR
  kg-live-private-cidr = "100.67.14.0/24"

  # KG Live Data Summary CIDR
  kg-live-data-cidr = "100.67.15.0/24"

  # Network secondary CIDR
  network-secondary-cidr = "100.64.8.0/22"

  # Network secondary CIDR B
  network-secondary-cidr-b = "100.67.8.0/22"

  # Network EUC1 CIDR
  network-secondary-cidr-euc1 = "100.71.4.0/23"

  # Training secondary CIDR
  training-secondary-cidr = "100.67.24.0/21"

  # Sandbox DevQA secondary CIDR
  sandbox-devqa-secondary-cidr = "100.68.24.0/21"

  # Sandbox MLAI secondary CIDR
  sandbox-mlai-secondary-cidr = "100.70.2.0/23"

  # Storage-sandbox secondary CIDR
  storage-sandbox-secondary-cidr = "100.68.5.0/24"

  # eis-storage-live secondary CIDR
  storage-live-secondary-cidr = "100.68.6.0/23"

  # sqldb-devqa secondary CIDR
  sqldb-devqa-secondary-cidr = "100.78.4.0/23"

  # prop-pub-cms-devqa secondary CIDR
  prop-pub-cms-devqa-secondary-cidr = "100.79.6.0/23"

  # prop-pub-cms-live secondary CIDR
  prop-pub-cms-live-secondary-cidr = "100.68.16.0/23"

  # VDI Summary CIDR
  vdi-secondary-summary-cidr = "100.71.0.0/16"

  # VDI DevQA secondary CIDR
  vdi-devqa-secondary-cidr = "100.71.1.0/24"

  # VDI Live secondary CIDR
  vdi-live-secondary-cidr = "100.71.3.0/24"

  # Velocity Cloud Dev CIDR
  velocity-cloud-dev-cidr = "10.61.0.0/16"

  # Velocity Cloud Live CIDR
  velocity-cloud-live-cidr = "10.193.0.0/16"

  # Zepheira DevQA secondary CIDR
  zepheira-devqa-secondary-cidr = "100.70.0.0/26"

  # Zepheira Live secondary CIDR
  zepheira-live-secondary-cidr = "100.70.0.128/26"

  # Zepheira Live secondary CIDR
  zepheira-shared-secondary-cidr = "100.70.0.64/26"

  # Zepheira Live secondary CIDR B
  zepheira-live-secondary-cidr-b = "100.72.0.0/23"

  # Zepheira DevQA secondary CIDR B
  zepheira-devqa-secondary-cidr-b = "100.72.2.0/23"

  # Zepheira Shared Services secondary CIDR B
  zepheira-shared-secondary-cidr-b = "100.72.4.0/23"

  # Zepheira LLN DevQA secondary CIDR
  zepheira-lln-devqa-secondary-cidr = "100.70.8.0/22"

  # Zepheira LLN Live secondary CIDR
  zepheira-lln-live-secondary-cidr = "100.70.12.0/22"

  # Full Text repository devqa Secondary CIDR
  full-text-repo-devqa-secondary-cidr = "100.79.0.0/22"

  # Full Text repository live Secondary CIDR
  full-text-repo-live-secondary-cidr = "100.67.100.0/22"

  # core automation dev Secondary CIDR
  core-automation-dev-secondary-cidr = "100.79.5.0/24"

  # core automation dev Secondary CIDR
  core-automation-live-secondary-cidr = "100.67.96.0/24"

  # ez proxy test dev Secondary CIDR
  ez-proxy-test-dev-secondary-cidr = "100.79.4.0/24"

  # Frankfurt AD DNS IPs
  ad-dns-ips-euc1 = ["100.68.4.77", "100.68.4.92"]

  # Summary for 100.68.4.0/22
  # This contains the eis-lz-ad networks, storage sandbox, storage live
  summary-ad-storage = "100.68.4.0/22"

  # Prophub-cms secondary CIDR
  prophub-cms-secondary-cidr = "100.68.16.0/23"

  common-tags = {
    app   = "landing-zone"
    owner = "arch.platform-architecture"
  }
}


