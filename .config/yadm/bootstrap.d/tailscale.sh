#!/bin/bash


# Attempts to install TailScale on this device 
if ! command -v tailscale &> /dev/null; then
	echo "Installing Tailscale"
	curl -fsSL https://tailscale.com/install.sh | sh
fi
if ! command -v tailscale status &> /dev/null; then
  tailscale up
fi

