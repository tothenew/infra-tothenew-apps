module "argocd" {
  source = "git::https://github.com/tothenew/terraform-helm-argocd.git"

  enabled = true
  helm_services = [
    {
      name          = "argocd"
      chart_version = "5.16.1"
      release_name  = "argo-cd"
      settings = {
        "server" = {
          "extraArgs" = [
              "--insecure",
          ]
          "ingress" = {
            "enabled" = true
            "https"   = true
            "annotations" = {
              "kubernetes.io/ingress.class"                    = "alb"
              "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
              "alb.ingress.kubernetes.io/target-type"          = "ip"
              "alb.ingress.kubernetes.io/success-codes"        = "200"
              "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
              "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80}]"
            }
          }
        }
      }
    }
  ]
}
