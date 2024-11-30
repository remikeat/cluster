#!/bin/bash
version=v1.8.3
id=$(curl -s -X POST --data-binary @assets.yaml https://factory.talos.dev/schematics | jq -r .id)
link=$(echo "factory.talos.dev/installer/$id:$version")
iso_link=$(echo "https://factory.talos.dev/image/$id/$version/metal-amd64.iso")
wget $iso_link
echo "$link" | xclip -selection clipboard
echo "$link"
