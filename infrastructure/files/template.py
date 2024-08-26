#!/bin/env python3

import os
import subprocess
import json
import sys


def get_value(params, name, value):
    return next((param[value] for param in params if param['name'] == name), None)


argocd_app_parameters = json.loads(os.getenv("ARGOCD_APP_PARAMETERS", "[]"))

if os.path.isfile("Chart.yaml"):
    cmd = ["helm", "template"]

    secrets = get_value(argocd_app_parameters, "secrets", "string")
    if secrets:
        cmd.extend(["-f", f"bw-secrets/{secrets}"])

    repo_values = get_value(argocd_app_parameters, "repo_values", "string")
    if repo_values:
        cmd.extend(["-f", "custom_values.yaml"])

    args = get_value(argocd_app_parameters, "args", "string")
    if args:
        cmd.extend(args.split())

    cmd.extend(["-n", os.getenv("ARGOCD_APP_NAMESPACE"),
               os.getenv("ARGOCD_APP_NAME"), "."])

    subprocess.run(cmd, check=True)

elif os.path.isfile("kustomization.yaml"):
    subprocess.run(["kustomize", "build"], check=True)

else:
    print("Neither Chart.yaml nor kustomization.yaml found.", file=sys.stderr)
