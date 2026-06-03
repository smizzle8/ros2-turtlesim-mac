#!/bin/bash
# Spawn 3 turtles at different positions

ENV_NAME="ros2"

find_conda_base() {
    for base in "$HOME/miniforge3" "$HOME/mambaforge" "$HOME/miniconda3" "$HOME/anaconda3"; do
        [ -d "$base/envs/$ENV_NAME" ] && echo "$base" && return
    done
    echo ""
}

CONDA_BASE=$(find_conda_base)
[ -z "$CONDA_BASE" ] && echo "ROS2 not found. Run: make install" && exit 1
ROS2="$CONDA_BASE/envs/$ENV_NAME/bin/ros2"

echo ""
echo "Spawning 3 turtles — make sure turtlesim_node is running first (make run)."
echo ""

sleep 2

echo "→ Spawning turtle2 at (3, 8)..."
"$ROS2" service call /spawn turtlesim/srv/Spawn "{x: 3.0, y: 8.0, theta: 0.0, name: 'turtle2'}"
sleep 1

echo "→ Spawning turtle3 at (8, 3)..."
"$ROS2" service call /spawn turtlesim/srv/Spawn "{x: 8.0, y: 3.0, theta: 1.57, name: 'turtle3'}"
sleep 1

echo "→ Spawning turtle4 at (5, 5)..."
"$ROS2" service call /spawn turtlesim/srv/Spawn "{x: 5.0, y: 5.0, theta: 3.14, name: 'turtle4'}"

echo ""
echo "Done. Control any turtle by publishing to /turtleN/cmd_vel"
echo ""
echo "Example — drive turtle2 in a circle:"
echo "  ros2 topic pub /turtle2/cmd_vel geometry_msgs/msg/Twist \"{linear: {x: 1.0}, angular: {z: 1.0}}\""
echo ""
