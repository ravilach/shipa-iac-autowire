#Deploy Container Image
resource "shipa_app" "tf-app" {
  depends_on = [shipa_cluster.tf-cluster]
  app {
    name = var.app_name
    teamowner = "shipa-team"
    framework = var.framework_name
  }
}

resource "shipa_app_deploy" "tf-app-deploy" {
  depends_on = [shipa_app.tf-app]
  app = shipa_app.tf-app.app[0].name
  deploy {
    image = var.app_image
  }
}