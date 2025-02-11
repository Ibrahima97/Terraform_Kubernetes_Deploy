variable "git_username" {
    type        = string
    description = "Nom d'utilisateur pour Git"
    }
variable "git_password" {
    type        = string
    description = "token d'accès personnel pour Git"
    sensitive   = true
}