#!/bin/bash
curl -s -X POST --data-binary @assets.yaml https://factory.talos.dev/schematics | jq -r .id
