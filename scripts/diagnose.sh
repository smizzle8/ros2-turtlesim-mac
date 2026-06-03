#!/bin/bash
# ROS2 install diagnostic — checks everything is working

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
pass() { echo -e "  ${GREEN}✓${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; FAILURES=$((FAILURES+1)); }
info() { echo -e "  ${BLUE}→${NC} $1"; }
FAILURES=0
QUICK=${1:-""}

ENV_NAME="ros2"

find_conda_base() {
    for base in "$HOME/miniforge3" "$HOME/mambaforge" "$HOME/miniconda3" "$HOME/anaconda3"; do
        [ -d "$base/envs/$ENV_NAME" ] && echo "$base" && return
    done
    echo ""
}

echo ""
echo -e "${BOLD}  ROS2 Diagnostic Report${NC}"
echo -e "  $(date)"
echo ""

# System
echo -e "${BOLD}  System${NC}"
info "macOS $(sw_vers -productVersion) | $(uname -m)"
info "Shell: $SHELL"

# Conda
echo ""
echo -e "${BOLD}  Conda / Mamba${NC}"
CONDA_BASE=$(find_conda_base)
if [ -n "$CONDA_BASE" ]; then
    pass "Conda base: $CONDA_BASE"
    MAMBA="$CONDA_BASE/bin/mamba"
    [ -f "$MAMBA" ] && pass "mamba: $($MAMBA --version 2>/dev/null | head -1)" || fail "mamba not found in $CONDA_BASE/bin"
else
    fail "No conda installation found with a ros2 environment"
    echo ""
    echo -e "  ${YELLOW}Run: make install${NC}"
    exit 1
fi

# Environment
echo ""
echo -e "${BOLD}  ROS2 Environment${NC}"
ENV_PATH="$CONDA_BASE/envs/$ENV_NAME"
if [ -d "$ENV_PATH" ]; then
    pass "Environment exists: $ENV_PATH"
    ROS2_BIN="$ENV_PATH/bin/ros2"
    [ -f "$ROS2_BIN" ] && pass "ros2 CLI: $ROS2_BIN" || fail "ros2 CLI not found"
    TURTLE_NODE="$ENV_PATH/lib/turtlesim/turtlesim_node"
    [ -f "$TURTLE_NODE" ] && pass "turtlesim_node binary found" || fail "turtlesim_node not found"
    RVIZ="$ENV_PATH/bin/rviz2"
    [ -f "$RVIZ" ] && pass "rviz2 found" || info "rviz2 not installed (optional)"
else
    fail "ros2 environment not found at $ENV_PATH"
    echo -e "  ${YELLOW}Run: make install${NC}"
    exit 1
fi

if [ "$QUICK" = "--quick" ]; then
    echo ""
    if [ $FAILURES -eq 0 ]; then
        echo -e "  ${GREEN}${BOLD}All checks passed. Run: make run${NC}"
    else
        echo -e "  ${RED}${BOLD}$FAILURES check(s) failed. Run: make diagnose for details.${NC}"
    fi
    echo ""
    exit $FAILURES
fi

# Python
echo ""
echo -e "${BOLD}  Python & rclpy${NC}"
PYTHON="$ENV_PATH/bin/python3"
if [ -f "$PYTHON" ]; then
    PY_VER=$("$PYTHON" --version 2>&1)
    pass "$PY_VER"
    "$PYTHON" -c "import rclpy" 2>/dev/null && pass "rclpy importable" || fail "rclpy import failed"
    "$PYTHON" -c "import turtlesim" 2>/dev/null && pass "turtlesim Python package importable" || fail "turtlesim Python package failed"
else
    fail "Python not found in environment"
fi

# Disk space
echo ""
echo -e "${BOLD}  Disk Space${NC}"
ENV_SIZE=$(du -sh "$ENV_PATH" 2>/dev/null | awk '{print $1}')
info "Environment size: $ENV_SIZE"
FREE=$(df -h "$HOME" | tail -1 | awk '{print $4}')
info "Free disk space: $FREE"

# Summary
echo ""
echo "  ─────────────────────────────────────"
if [ $FAILURES -eq 0 ]; then
    echo -e "  ${GREEN}${BOLD}All checks passed!${NC}"
    echo ""
    echo -e "  ${BOLD}make run${NC}   → launch turtlesim"
    echo -e "  ${BOLD}make demo${NC}  → automated demo"
else
    echo -e "  ${RED}${BOLD}$FAILURES check(s) failed.${NC}"
    echo ""
    echo -e "  Try: ${YELLOW}make uninstall && make install${NC}"
fi
echo ""
exit $FAILURES
