#!/bin/bash
ansible-playbook -i inventory.yml shutdown.yml --ask-become
