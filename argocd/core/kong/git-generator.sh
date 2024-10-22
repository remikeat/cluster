#!/bin/bash

resourceList=$(cat)

repoURL=$(echo "$resourceList" | yq e '.functionConfig.spec.repoURL' - )
path=$(echo "$resourceList" | yq e '.functionConfig.spec.path' - )
targetRevision=$(echo "$resourceList" | yq e '.functionConfig.spec.targetRevision' - )
patch=$(echo "$resourceList" | yq e '.functionConfig.spec.patch' - )
valuesFile=$(echo "$resourceList" | yq e '.functionConfig.spec.valuesFile' - )
name=$(echo "$resourceList" | yq e '.functionConfig.spec.name' - )
namespace=$(echo "$resourceList" | yq e '.functionConfig.spec.namespace' - )
skipCrds=$(echo "$resourceList" | yq e '.functionConfig.spec.skipCrds' - )

git clone -q --single-branch --branch=$targetRevision $repoURL $name &> /dev/null
patch -d $name -p1 < $patch &> /dev/null
helmCommand=("helm" "template" "$name" "-n" "$namespace" "-f" "$valuesFile" "$name/$path")
if [ "$skipCrds" = "true" ]; then
    helmCommand+=("--skip-crds")
fi
"${helmCommand[@]}" 2>/dev/null
rm -rf $name
