variable "git_username" {
    type        = string
    description = "Nom d'utilisateur pour Git"
    }
variable "git_password" {
    type        = string
    description = "token d'accès personnel pour Git"
    sensitive   = true
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "airflow" {
	source = "./modules/airflow"

  git_username = var.git_username
  git_password = var.git_password
}