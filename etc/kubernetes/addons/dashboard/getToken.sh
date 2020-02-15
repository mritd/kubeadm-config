#!/usr/bin/env bash

kubectl -n kube-addons describe secret $(kubectl -n kube-addons get secret | grep dashboard-admin | awk '{print $1}')
