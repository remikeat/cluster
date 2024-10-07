#!/bin/sh

resourceList=$(cat)

repoURL=$(echo "$resourceList" | yq e '.functionConfig.spec.repoURL' - )
path=$(echo "$resourceList" | yq e '.functionConfig.spec.path' - )
targetRevision=$(echo "$resourceList" | yq e '.functionConfig.spec.targetRevision' - )
valuesFile=$(echo "$resourceList" | yq e '.functionConfig.spec.valuesFile' - )
name=$(echo "$resourceList" | yq e '.functionConfig.spec.name' - )
namespace=$(echo "$resourceList" | yq e '.functionConfig.spec.namespace' - )

git clone -q --single-branch --branch=$targetRevision $repoURL repo
helm template $name -n $namespace -f $valuesFile repo/$path 2>/dev/null
rm -rf repo
