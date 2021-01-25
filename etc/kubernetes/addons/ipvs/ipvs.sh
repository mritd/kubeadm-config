#!/usr/bin/env bash

set -e

# Kernel modules
cat > /etc/modules-load.d/50-kubernetes.conf <<EOF
# Load some kernel modules needed by kubernetes at boot
nf_conntrack
br_netfilter
ip_vs
ip_vs_lc
ip_vs_wlc
ip_vs_rr
ip_vs_wrr
ip_vs_lblc
ip_vs_lblcr
ip_vs_dh
ip_vs_sh
ip_vs_fo
ip_vs_nq
ip_vs_sed
EOF

# sysctl
cat > /etc/sysctl.d/50-kubernetes.conf <<EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
EOF
