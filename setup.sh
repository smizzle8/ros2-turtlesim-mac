#!/bin/bash
set -e

# ROS2 Turtlesim Mac Setup — RoboStack (no VM required)
# Supports: macOS Apple Silicon (arm64) & Intel (x86_64)

MAMBA=""
ENV_NAME="ros2"
ROS_DISTRO="jazzy"

echo "================================================"
echo " ROS2 Turtlesim Setup for macOS"
echo "================================================"
echo ""

# Find mamba
if command -v mamba &>/dev/null; then
    MAMBA="mamba"
elif [ -f "$HOME/miniforge3/bin/mamba" ]; then
    MAMBA="$HOME/miniforge3/bin/mamba"
elif [ -f "$HOME/mambaforge/bin/mamba" ]; then
    MAMBA="$HOME/mambaforge/bin/mamba"
else
    echo "mamba not found. Installing Miniforge..."
    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        curl -fsSL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh -o /tmp/miniforge.sh
    else
        curl -fsSL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh -o /tmp/miniforge.sh
    fi
    bash /tmp/miniforge.sh -b -p "$HOME/miniforge3"
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
    source "$HOME/miniforge3/etc/profile.d/mamba.sh"
    MAMBA="$HOME/miniforge3/bin/mamba"
fi

echo "Using: $MAMBA"
echo ""

# Check if environment already exists
CONDA_BASE=$(dirname $(dirname $MAMBA))
if [ -d "$CONDA_BASE/envs/$ENV_NAME" ]; then
    echo "Environment '$ENV_NAME' already exists — skipping creation."
else
    echo "Creating ROS2 $ROS_DISTRO environment (this takes ~5-10 minutes)..."
    "$MAMBA" create -n "$ENV_NAME" \
        -c robostack-staging \
        -c conda-forge \
        --no-channel-priority \
        ros-${ROS_DISTRO}-desktop \
        ros-${ROS_DISTRO}-turtlesim \
        python=3.11 \
        -y
    echo ""
    echo "Environment created successfully."
fi

echo ""
echo "================================================"
echo " Setup complete!"
echo " Run: bash launch_turtlesim.sh"
echo "================================================"
