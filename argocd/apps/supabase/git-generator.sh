#!/bin/bash

resourceList=$(cat)

repoURL=$(echo "$resourceList" | yq e '.functionConfig.spec.repoURL // ""' - )
path=$(echo "$resourceList" | yq e '.functionConfig.spec.path // ""' - )
targetRevision=$(echo "$resourceList" | yq e '.functionConfig.spec.targetRevision // ""' - )
patch=$(echo "$resourceList" | yq e '.functionConfig.spec.patch // ""' - )
valuesFile=$(echo "$resourceList" | yq e '.functionConfig.spec.valuesFile // ""' - )
name=$(echo "$resourceList" | yq e '.functionConfig.spec.name // ""' - )
namespace=$(echo "$resourceList" | yq e '.functionConfig.spec.namespace // ""' - )
skipCrds=$(echo "$resourceList" | yq e '.functionConfig.spec.skipCrds // ""' - )
apiVersions=$(echo "$resourceList" | yq e '.functionConfig.spec.apiVersions // ""' - )

git clone -q --single-branch --branch=$targetRevision $repoURL $name &> /dev/null
if [ -z "$patch" ]; then
    patch -d $name -p1 < $patch &> /dev/null
fi
helmCommand=("helm" "template" "$name" "-n" "$namespace")
if [ -z "$valuesFile" ]; then
    helmCommand+=("-f" "$valuesFile")
fi
if [ "$skipCrds" = "true" ]; then
    helmCommand+=("--skip-crds")
fi
if [ -z "$apiVersions" ]; then
    helmCommand+=("-a" "$apiVersions")
fi
helmCommand+=("$name/$path")
"${helmCommand[@]}" 2>/dev/null
rm -rf $name
