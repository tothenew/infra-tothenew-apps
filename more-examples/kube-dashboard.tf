module "kube_dashboard" {
  source = "git::https://github.com/tothenew/terraform-aws-eks-generic-chart.git"

  helm_chart_name         = "kubernetes-dashboard"
  helm_chart_release_name = "kubernetes-dashboard"
  helm_chart_version      = "6.0.0"
  helm_chart_repo         = "https://kubernetes.github.io/dashboard/"
  namespace               = "kube-system"

  settings = {}
}
