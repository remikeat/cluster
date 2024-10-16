#!/bin/env python

import requests
import json
import jwt
from base64 import b64decode
import jwt
from cryptography.hazmat.primitives import serialization
import os
from dotenv import load_dotenv

load_dotenv()

url = os.getenv("url")
realm = os.getenv("realm")
client_id = os.getenv("client_id")
client_secret = os.getenv("client_secret")
username = os.getenv("username")
password = os.getenv("password")

realm_url = f"{url}/realms/{realm}"
public_key_url = realm_url
token_url = f"{realm_url}/protocol/openid-connect/token"
introspect_url = f"{token_url}/introspect"


def get_public_key(public_key_url):
    response = requests.request("GET", public_key_url)
    json_res = json.loads(response.text)
    public_key = json_res["public_key"]
    key_der = b64decode(public_key.encode())
    public_key = serialization.load_der_public_key(key_der)
    return public_key


def get_data(url, payload):
    client_payload = {
        "client_id": client_id,
        "client_secret": client_secret
    }
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    response = requests.request(
        "POST", url, headers=headers, data=client_payload | payload)
    json_res = json.loads(response.text)
    return json_res


def get_token(token_url, grant_type, payload, token_type):
    data = get_data(token_url, {"grant_type": grant_type} | payload)
    token = data[token_type]
    return token


def validate_token_offline(public_key_url, access_token):
    public_key = get_public_key(public_key_url)
    res = jwt.decode(access_token, public_key, algorithms=["RS256"], options={
        "verify_aud": False, "verify_signature": True})
    return res


def validate_token_online(introspect_url, access_token):
    return get_data(introspect_url, {"token": access_token})


def pretty_print_dict(dict):
    print(json.dumps(dict, indent=4))


refresh_token = get_token(token_url, "password", {
                          "username": username, "password": password}, "refresh_token")

access_token = get_token(token_url, "refresh_token", {
                         "refresh_token": refresh_token}, "access_token")

res = validate_token_offline(public_key_url, access_token)
pretty_print_dict(res)

res = validate_token_online(introspect_url, access_token)
print(res["active"])
