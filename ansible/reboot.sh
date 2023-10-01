#!/bin/bash
ansible-playbook -i inventory.yml reboot.yml --ask-become
