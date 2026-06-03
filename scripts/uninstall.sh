#!/bin/bash
# Remove the ROS2 conda environment

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; NC='\033[0m'

ENV_NAME="ros2"

find_mamba() {
    for path in "$HOME/miniforge3/bin/mamba" "$HOME/mambaforge/bin/mamba" "$HOME/miniconda3/bin/mamba"; do
        [ -f "$path" ] && echo "$path" && return
    done
    echo ""
}

MAMBA=$(find_mamba)
[ -z "$MAMBA" ] && echo -e "${RED}✗${NC} mamba not found." && exit 1

CONDA_BASE=$(dirname "$(dirname "$MAMBA")")
ENV_PATH="$CONDA_BASE/envs/$ENV_NAME"

if [ ! -d "$ENV_PATH" ]; then
    echo -e "${YELLOW}⚠${NC}  Environment '$ENV_NAME' not found — nothing to remove."
    exit 0
fi

ENV_SIZE=$(du -sh "$ENV_PATH" 2>/dev/null | awk '{print $1}')
echo ""
echo -e "${YELLOW}This will remove the ros2 environment (${ENV_SIZE}).${NC}"
read -p "Continue? [y/N] " -n 1 -r; echo
[[ ! $REPLY =~ ^[Yy]$ ]] && echo "Cancelled." && exit 0

echo ""
echo -e "${YELLOW}→${NC} Removing $ENV_PATH..."
"$MAMBA" env remove -n "$ENV_NAME" -y
rm -f "$HOME/.ros2_activate"
echo -e "${GREEN}✓${NC} Removed. Run 'make install' to reinstall."
echo ""
