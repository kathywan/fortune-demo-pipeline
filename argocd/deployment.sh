#!/bin/bash -e

ARGOCD_URL=argocd.sharedsvc.home.kwpivotal.com

KUBE_CONTEXT_DEV=tkgi-small-wlc
KUBE_API_DEV="$( kubectl config view -o jsonpath="{.clusters[?(@.name=='$KUBE_CONTEXT_DEV')].cluster.server}")"
DEST_NAMESPACE_DEV=fortune-dev

KUBE_CONTEXT_PROD=tkgi-small-wlc
KUBE_API_PROD="$( kubectl config view -o jsonpath="{.clusters[?(@.name=='$KUBE_CONTEXT_PROD')].cluster.server}")"
DEST_NAMESPACE_PROD=fortune-prod

APP_DEPLOY_REPO=https://github.com/kathywan/fortune-demo-pipeline.git

argocd login $ARGOCD_URL
argocd cluster add $KUBE_CONTEXT_DEV
argocd cluster add $KUBE_CONTEXT_PROD

###Fortune app to dev:
argocd app create fortune-app-dev \
  --repo $APP_DEPLOY_REPO \
  --path kustomize/dev \
  --dest-server $KUBE_API_DEV \
  --dest-namespace $DEST_NAMESPACE_DEV \
  --sync-policy automated

argocd app sync fortune-app-dev 
argocd app wait fortune-app-dev 

###Fortune app to prod:
argocd app create fortune-app-prod \
  --repo $APP_DEPLOY_REPO \
  --path kustomize/dev \
  --dest-server $KUBE_API_PROD \
  --dest-namespace $DEST_NAMESPACE_PROD \
  --sync-policy automated

argocd app sync fortune-app-prod 
argocd app wait fortune-app-prod