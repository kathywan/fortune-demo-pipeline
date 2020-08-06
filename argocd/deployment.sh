#!/bin/bash -e

ARGOCD_URL=argocd.sharedsvc.home.kwpivotal.com
KUBE_CONTEXT=tkgi-small-wlc
KUBE_API="$( kubectl config view -o jsonpath="{.clusters[?(@.name=='$KUBE_CONTEXT')].cluster.server}")"
DEST_NAMESPACE=fortune-dev
APP_DEPLOY_REPO=https://github.com/kathywan/fortune-demo-pipeline.git

argocd login $ARGOCD_URL
argocd cluster add $KUBE_CONTEXT

###Fortune app:
argocd app create fortune-app-dev \
  --repo $APP_DEPLOY_REPO \
  --path kustomize/dev \
  --dest-server $KUBE_API \
  --dest-namespace $DEST_NAMESPACE \
  --sync-policy automated
