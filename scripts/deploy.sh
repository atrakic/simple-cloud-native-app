#!/usr/bin/env bash

: "${APP:?'You need to configure the APP environment variable!'}"
: "${IMAGE:?'You need to configure the IMAGE environment variable!'}"
: "${NS:=default}"
: "${RS:=1}"
: "${PORT:=80}"

set -e
set -o pipefail

main() {
  kubectl config current-context
  kubectl cluster-info

  [[ ${NS} != "default" ]] && { kubectl create namespace "$NS" || true; }

  kubectl --namespace "$NS" create deployment "$APP" --image "$IMAGE" --replicas="$RS" --dry-run=client -o yaml | sed -n '/status/q;p' | grep -Ev "creationTimestamp" | kubectl apply -f -
  kubectl --namespace "$NS" rollout status deployment "$APP"
  [[ ${NS} != "default" ]] && { kubectl --namespace "$NS" rollout restart deployment "$APP"; }
  kubectl --namespace "$NS" rollout history deployment/"$APP"

  kubectl --namespace "$NS" create service clusterip "$APP" --tcp=80:"$PORT" --dry-run=client -o yaml | sed -n '/status/q;p' | grep -Ev "creationTimestamp" | kubectl apply -f -
  kubectl --namespace "$NS" get all -o wide

  if [[ -n $INGRESS_HOST ]]; then
    cat <<EOF | kubectl --namespace "$NS" apply -f -
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: $APP
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host: $INGRESS_HOST
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
           name: $APP
           port:
             number: 80
EOF
    kubectl --namespace "$NS" get ingress
  fi
}

main "$@"
