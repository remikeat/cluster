#!/bin/sh
case "$1" in
    Username*) echo "${GIT_USERNAME}" ;;
    Password*) echo "${GIT_TOKEN}" ;;
esac
