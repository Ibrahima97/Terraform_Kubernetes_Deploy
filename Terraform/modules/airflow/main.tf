resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

resource "kubernetes_secret" "airflow-http-git-secret" {
  metadata {
    name      = "airflow-http-git-secret"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }

  data = {
    username = var.git_username
    password = var.git_password
  }

  type = "Opaque"
}

resource "helm_release" "airflow" {

  name       = "airflow"
  namespace  = kubernetes_namespace.airflow.metadata[0].name
  chart      = "airflow"
  repository = "https://airflow-helm.github.io/charts"
  version    = "8.8.0" # version existante dans le depot

  values = [
    file("${path.module}/values.yaml")
  ]
}
