#!/bin/bash
# Record turtle movements to a rosbag and replay them

ENV_NAME="ros2"

find_conda_base() {
    for base in "$HOME/miniforge3" "$HOME/mambaforge" "$HOME/miniconda3" "$HOME/anaconda3"; do
        [ -d "$base/envs/$ENV_NAME" ] && echo "$base" && return
    done
    echo ""
}

CONDA_BASE=$(find_conda_base)
[ -z "$CONDA_BASE" ] && echo "ROS2 not found. Run: make install" && exit 1

ACTIVATE="source $CONDA_BASE/etc/profile.d/conda.sh && conda activate $ENV_NAME"
BAG_DIR="$HOME/ros2_bags/turtle_session_$(date +%Y%m%d_%H%M%S)"

echo ""
echo "ROS2 Bag — Record & Replay turtle movements"
echo ""
echo "This will:"
echo "  1. Record /turtle1/cmd_vel for 15 seconds while you drive"
echo "  2. Replay the recording so the turtle repeats your movements"
echo ""
read -p "Start? [y/N] " -n 1 -r; echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0

echo ""
echo "→ Recording to: $BAG_DIR"
echo "  Drive the turtle now (make sure turtlesim + teleop are running)."
echo "  Recording for 15 seconds..."
echo ""

osascript <<EOF
tell application "Terminal"
    do script "$ACTIVATE && ros2 bag record -o '$BAG_DIR' /turtle1/cmd_vel /turtle1/pose && echo 'Recording saved to $BAG_DIR'"
    activate
end tell
EOF

sleep 17

echo ""
echo "→ Replaying recording..."
echo "  Watch the turtle repeat your movements!"
echo ""

osascript <<EOF
tell application "Terminal"
    do script "$ACTIVATE && ros2 bag play '$BAG_DIR'"
    activate
end tell
EOF

echo ""
echo "Bag file saved at: $BAG_DIR"
echo "Replay manually anytime with:"
echo "  ros2 bag play $BAG_DIR"
echo ""
