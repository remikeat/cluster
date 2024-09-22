#!/bin/env python3

import os
import shutil
import subprocess
import json


def get_value(params, name, value):
    if params:
        return next((param[value]
                    for param in params if param['name'] == name), None)
    else:
        return None


argocd_app_parameters = json.loads(os.getenv("ARGOCD_APP_PARAMETERS", "[]"))

os.makedirs("bw-secrets", exist_ok=True)
shutil.copytree("/bw-secrets", "./bw-secrets", dirs_exist_ok=True)

repo_url = get_value(argocd_app_parameters, "repo_url", "string")
if repo_url:
    subprocess.run(["git", "clone", "--quiet", repo_url,
                   "/repo/custom_values"], check=True)

repo_revision = get_value(argocd_app_parameters, "repo_revision", "string")
if repo_revision:
    subprocess.run(["git", "checkout", "--quiet", repo_revision],
                   cwd="/repo/custom_values", check=True)

repo_values = get_value(argocd_app_parameters, "repo_values", "string")
if repo_values:
    shutil.copy(f"/repo/custom_values/{repo_values}", "custom_values.yaml")

if repo_url:
    shutil.rmtree("/repo/custom_values")
