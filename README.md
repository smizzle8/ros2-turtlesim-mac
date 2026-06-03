# ROS2 Humble on macOS — No VM Required

Run a full ROS2 Humble stack natively on macOS using [RoboStack](https://robostack.github.io/) — no virtual machine, no Docker, no X11. Works on Apple Silicon (M1/M2/M3/M4/M5) and Intel Macs.

Includes turtlesim, rviz2, rosbag2, and example Python nodes.

---

## Requirements

- macOS 12 or later
- Terminal
- Internet connection (for first-time install)

That's it. The setup script handles everything else.

---

## Quick Start

```bash
git clone https://github.com/smizzle8/ros2-turtlesim-mac.git
cd ros2-turtlesim-mac
make install
```

Takes ~5–10 minutes on first run (downloads ~500 packages). Then:

```bash
make run      # launch turtlesim + keyboard control
make demo     # watch the turtle draw shapes automatically
make check    # verify everything is working
```

---

## What Gets Installed

| Package | What it is |
|---------|-----------|
| `ros-humble-desktop` | Full ROS2 Humble desktop stack |
| `ros-humble-turtlesim` | The turtle simulator |
| `ros-humble-rviz2` | 3D visualization tool |
| `ros-humble-rosbag2` | Record and replay ROS2 data |
| `colcon` | Build tool for your own packages |

All installed into an isolated `ros2` conda environment — nothing touches your system Python.

---

## Commands

```
make install    install ROS2 (first time)
make run        launch turtlesim with keyboard control
make demo       automated demo — turtle draws shapes
make multi      spawn 3 turtles at once
make check      quick health check
make diagnose   full diagnostic report
make uninstall  remove the ros2 environment
make examples   list example scripts
```

---

## Examples

### Draw shapes automatically (Python)
```bash
source ~/.ros2_activate
python3 examples/draw_shapes.py
```
Draws a circle, square, and spiral using `rclpy`.

### Spawn multiple turtles
```bash
make multi
```
Spawns 3 turtles. Drive any of them:
```bash
ros2 topic pub /turtle2/cmd_vel geometry_msgs/msg/Twist "{linear: {x: 1.0}, angular: {z: 1.0}}"
```

### Publisher / Subscriber in Python
```bash
source ~/.ros2_activate
python3 examples/hello_ros2.py
```
A minimal `rclpy` node pair — good starting point for your own ROS2 code.

### Record and replay turtle movements
```bash
bash examples/rosbag_record.sh
```
Records your movements for 15 seconds, then replays them so the turtle copies you.

---

## Manual Launch (without `make`)

Open 2 Terminal tabs:

```bash
# Tab 1 — turtlesim window
source ~/.ros2_activate
ros2 run turtlesim turtlesim_node

# Tab 2 — keyboard control (arrow keys)
source ~/.ros2_activate
ros2 run turtlesim turtle_teleop_key
```

---

## Useful ROS2 Commands

```bash
# List all active topics
ros2 topic list

# Watch the turtle's position live
ros2 topic echo /turtle1/pose

# Drive in a circle
ros2 topic pub /turtle1/cmd_vel geometry_msgs/msg/Twist \
  "{linear: {x: 2.0}, angular: {z: 1.8}}"

# Clear the drawing canvas
ros2 service call /clear std_srvs/srv/Empty

# Kill a turtle
ros2 service call /kill turtlesim/srv/Kill "{name: 'turtle1'}"

# Launch rviz2
ros2 run rviz2 rviz2

# List all nodes
ros2 node list
```

---

## Troubleshooting

**`conda activate ros2` not working in a new terminal?**
```bash
source ~/.ros2_activate
```

**Turtlesim window doesn't appear?**
Make sure you're running `turtlesim_node` in a terminal where the `ros2` environment is activated.

**Setup fails midway?**
```bash
make uninstall
make install
```

**Full diagnostic:**
```bash
make diagnose
```

---

## How It Works

[RoboStack](https://robostack.github.io/) pre-builds ROS2 packages as native conda packages compiled against macOS system Qt — so GUI apps like turtlesim and rviz2 open as real macOS windows with no X11 or display forwarding needed.
