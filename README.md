# ROS2 Turtlesim on macOS — No VM Required

Run ROS2 Humble and turtlesim natively on macOS (Apple Silicon & Intel) using [RoboStack](https://robostack.github.io/). No virtual machine, no Docker, no XQuartz needed.

## Requirements

- macOS 12+ (Apple Silicon or Intel)
- Terminal

That's it.

## Quick Start

### 1. Run setup (one time only)

```bash
bash setup.sh
```

This installs ROS2 Humble + turtlesim into an isolated conda environment. Takes ~5–10 minutes on first run.

### 2. Launch turtlesim

```bash
bash launch_turtlesim.sh
```

Three Terminal windows will open:
- **Turtle window** — the turtlesim GUI
- **Teleop window** — use arrow keys to drive the turtle
- **Topic monitor** — lists active ROS2 topics

## Manual Launch (if you prefer)

Open 3 separate Terminal tabs and run one command in each:

```bash
# Tab 1 — start turtlesim
conda activate ros2 && ros2 run turtlesim turtlesim_node

# Tab 2 — keyboard control (arrow keys)
conda activate ros2 && ros2 run turtlesim turtle_teleop_key

# Tab 3 — spawn a second turtle (optional)
conda activate ros2 && ros2 service call /spawn turtlesim/srv/Spawn "{x: 5.0, y: 5.0, theta: 0.0, name: 'turtle2'}"
```

## Useful ROS2 Commands

```bash
# List all active topics
ros2 topic list

# Watch the turtle's position live
ros2 topic echo /turtle1/pose

# Draw a circle automatically
ros2 topic pub /turtle1/cmd_vel geometry_msgs/msg/Twist \
  "{linear: {x: 2.0}, angular: {z: 1.8}}"

# Clear the drawing
ros2 service call /clear std_srvs/srv/Empty
```

## Troubleshooting

**`conda activate ros2` not working?**
Run this first: `source ~/miniforge3/etc/profile.d/conda.sh`

**Turtlesim window doesn't open?**
Make sure you're running `turtlesim_node` in a Terminal with the `ros2` environment activated, not just any terminal.

**Setup fails partway?**
Delete the broken environment and retry:
```bash
~/miniforge3/bin/mamba env remove -n ros2
bash setup.sh
```

## How It Works

[RoboStack](https://robostack.github.io/) packages ROS2 as native conda packages built against macOS's system Qt — so turtlesim opens as a real macOS window with no X11 forwarding needed.
