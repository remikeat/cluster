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
argocd_app_name = os.getenv("ARGOCD_APP_NAME")

git_repo_path = f"/repo/{argocd_app_name}-custom_values"

os.makedirs("bw-secrets", exist_ok=True)
shutil.copytree("/bw-secrets", "./bw-secrets", dirs_exist_ok=True)

repo_url = get_value(argocd_app_parameters, "repo_url", "string")
if repo_url:
    subprocess.run(["git", "clone", "--quiet",
                   repo_url, git_repo_path], check=True)

repo_revision = get_value(argocd_app_parameters, "repo_revision", "string")
if repo_revision:
    subprocess.run(["git", "checkout", "--quiet", repo_revision],
                   cwd=git_repo_path, check=True)

repo_values = get_value(argocd_app_parameters, "repo_values", "string")
if repo_values:
    shutil.copy(
        f"{git_repo_path}/{repo_values}", f"{argocd_app_name}-custom_values.yaml")

if repo_url:
    shutil.rmtree(git_repo_path)
