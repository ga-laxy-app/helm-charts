```yaml
certs:
  ssl:
    issuerRef:
      group: cert-manager.io
      kind: ClusterIssuer
      name: galaxy
ingress:
  annotations:
    kubernetes.io/tls-acme: "true"
  className: traefik
  enabled: true
  hosts:
    - host: idm.ga.laxy.app
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - hosts:
        - idm.ga.laxy.app
      secretName: kanidm-ingress-tls
kanidm:
  domain: idm.ga.laxy.app
  ldap:
    enabled: true
  logLevel: debug
  web:
    service:
      annotations:
        traefik.ingress.kubernetes.io/service.serversscheme: https
        traefik.ingress.kubernetes.io/service.serverstransport: kube-ingress-galaxy-internal@kubernetescrd
    trustXForwardFor: true
```
