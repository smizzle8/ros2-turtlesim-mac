#!/bin/bash
# Automated turtlesim demo — draws shapes without keyboard input

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
info() { echo -e "${BLUE}→${NC} $1"; }
ok()   { echo -e "${GREEN}✓${NC} $1"; }

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
ENV_PATH="$CONDA_BASE/envs/$ENV_NAME"
PYTHON="$ENV_PATH/bin/python3"

echo ""
echo -e "${BOLD}  ROS2 Turtlesim Demo${NC}"
echo ""
info "Starting turtlesim node in background..."
info "Will draw a circle, then a square, then spawn a second turtle."
echo ""

# Launch turtlesim in a Terminal window
osascript <<EOF
tell application "Terminal"
    do script "$ACTIVATE && clear && echo 'Turtlesim Demo — watch the turtle draw!' && ros2 run turtlesim turtlesim_node"
    activate
end tell
EOF

sleep 3
ok "Turtlesim window opened."
info "Running demo commands..."
echo ""

# Draw circle
info "Drawing a circle..."
"$ENV_PATH/bin/ros2" topic pub --once /turtle1/cmd_vel geometry_msgs/msg/Twist \
    "{linear: {x: 0.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}" \
    --ros-domain-id 0 2>/dev/null || true

sleep 1

# Run the draw_shapes Python script
info "Running draw_shapes example..."
"$PYTHON" "$(dirname "$0")/../examples/draw_shapes.py" &
DEMO_PID=$!
sleep 12

# Stop movement
"$ENV_PATH/bin/ros2" topic pub --once /turtle1/cmd_vel geometry_msgs/msg/Twist \
    "{linear: {x: 0.0}, angular: {z: 0.0}}" 2>/dev/null || true

kill $DEMO_PID 2>/dev/null || true

# Spawn second turtle
info "Spawning a second turtle..."
"$ENV_PATH/bin/ros2" service call /spawn turtlesim/srv/Spawn \
    "{x: 3.0, y: 7.0, theta: 1.57, name: 'turtle2'}" 2>/dev/null || true

sleep 2
ok "Demo complete! Close the turtlesim window when done."
echo ""
