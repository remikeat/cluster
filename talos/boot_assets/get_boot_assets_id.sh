#!/bin/bash

id=$(curl -s -X POST --data-binary @assets.yaml https://factory.talos.dev/schematics | jq -r .id)
link=$(echo "factory.talos.dev/installer/$id:v1.7.6")
echo "$link" | xclip -selection clipboard
echo "$link"
