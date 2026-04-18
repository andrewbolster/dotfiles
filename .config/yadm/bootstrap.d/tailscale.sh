#!/bin/bash

# Optional Tailscale installation - safe to fail on work machines
echo "Attempting to install Tailscale (optional)..."

# Attempts to install TailScale on this device
if ! command -v tailscale &> /dev/null; then
	echo "Installing Tailscale..."
	if curl -fsSL https://tailscale.com/install.sh | sh; then
		echo "Tailscale installation completed"
	else
		echo "Warning: Tailscale installation failed (this is OK for work machines)"
		exit 0  # Exit successfully to not break bootstrap
	fi
fi

# Try to bring up Tailscale if the command is available
if command -v tailscale &> /dev/null; then
	echo "Attempting to start Tailscale..."
	if ! tailscale status &> /dev/null; then
		echo "Note: Run 'sudo tailscale up' manually when ready to connect"
	else
		echo "Tailscale is already connected"
	fi
else
	echo "Tailscale command not available after installation (may require App Store install)"
	echo "Install manually from App Store if needed"
fi

echo "Tailscale bootstrap completed (optional install)"

