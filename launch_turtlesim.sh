#!/bin/bash
# Launch ROS2 turtlesim — opens 3 Terminal tabs automatically

MAMBA=""
ENV_NAME="ros2"

# Find mamba/conda base
if [ -f "$HOME/miniforge3/bin/mamba" ]; then
    CONDA_BASE="$HOME/miniforge3"
elif [ -f "$HOME/mambaforge/bin/mamba" ]; then
    CONDA_BASE="$HOME/mambaforge"
elif [ -f "$HOME/miniconda3/bin/conda" ]; then
    CONDA_BASE="$HOME/miniconda3"
else
    echo "Could not find conda/mamba. Run setup.sh first."
    exit 1
fi

ACTIVATE="source $CONDA_BASE/etc/profile.d/conda.sh && conda activate $ENV_NAME"

echo "Launching turtlesim..."
echo ""
echo "This will open 3 Terminal windows:"
echo "  1. turtlesim node (the turtle window)"
echo "  2. keyboard teleop (use arrow keys to drive)"
echo "  3. ROS2 topic monitor"
echo ""

# Open 3 Terminal windows via AppleScript
osascript <<EOF
tell application "Terminal"
    -- Window 1: turtlesim node
    do script "$ACTIVATE && ros2 run turtlesim turtlesim_node"
    delay 2

    -- Window 2: teleop
    do script "$ACTIVATE && echo 'Use arrow keys to drive the turtle. Press Q to quit.' && ros2 run turtlesim turtle_teleop_key"
    delay 1

    -- Window 3: topic list
    do script "$ACTIVATE && echo 'Active ROS2 topics:' && ros2 topic list"

    activate
end tell
EOF

echo "Done — check your Terminal windows."
