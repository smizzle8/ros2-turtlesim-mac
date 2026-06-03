#!/bin/bash
# Launch ROS2 turtlesim on macOS

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }
die()  { echo -e "${RED}✗${NC} $1"; exit 1; }

ENV_NAME="ros2"

# Find conda base
find_conda_base() {
    for base in "$HOME/miniforge3" "$HOME/mambaforge" "$HOME/miniconda3" "$HOME/anaconda3"; do
        [ -d "$base/envs/$ENV_NAME" ] && echo "$base" && return
    done
    echo ""
}

CONDA_BASE=$(find_conda_base)
[ -z "$CONDA_BASE" ] && die "ROS2 environment not found. Run: make install"

ACTIVATE="source $CONDA_BASE/etc/profile.d/conda.sh && conda activate $ENV_NAME"

echo ""
echo -e "${BOLD}  Launching ROS2 Turtlesim${NC}"
echo ""
ok "Environment: $CONDA_BASE/envs/$ENV_NAME"
info "Opening 2 Terminal windows..."
echo ""
echo -e "  ${BOLD}Window 1:${NC} turtlesim node (the turtle)"
echo -e "  ${BOLD}Window 2:${NC} keyboard teleop (arrow keys to drive, Q to quit)"
echo ""

osascript <<EOF
tell application "Terminal"
    set w1 to do script "$ACTIVATE && clear && echo '' && echo '  ROS2 Turtlesim — starting...' && echo '' && ros2 run turtlesim turtlesim_node"
    delay 2
    set w2 to do script "$ACTIVATE && clear && echo '' && echo '  Keyboard Control — use arrow keys to drive the turtle' && echo '  Press Q to quit.' && echo '' && ros2 run turtlesim turtle_teleop_key"
    activate
end tell
EOF

echo -e "${GREEN}Done.${NC} Use arrow keys in Window 2 to drive the turtle."
echo ""
echo -e "  ${YELLOW}Tip:${NC} run ${BOLD}make demo${NC} to watch the turtle draw automatically."
echo ""
