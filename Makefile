.PHONY: install run demo check examples uninstall help

help:
	@echo ""
	@echo "  ROS2 Humble for macOS"
	@echo ""
	@echo "  make install    — install ROS2 + turtlesim (first time setup)"
	@echo "  make run        — launch turtlesim with keyboard control"
	@echo "  make demo       — run the automated circle demo"
	@echo "  make multi      — spawn 3 turtles"
	@echo "  make check      — verify the install is working"
	@echo "  make diagnose   — full diagnostic report"
	@echo "  make uninstall  — remove the ros2 environment"
	@echo "  make examples   — list available example scripts"
	@echo ""

install:
	@bash setup.sh

run:
	@bash launch_turtlesim.sh

demo:
	@bash scripts/demo.sh

multi:
	@bash examples/multi_turtle.sh

check:
	@bash scripts/diagnose.sh --quick

diagnose:
	@bash scripts/diagnose.sh

uninstall:
	@bash scripts/uninstall.sh

examples:
	@echo ""
	@echo "  Available examples (run with: bash examples/<name>)"
	@echo ""
	@echo "  examples/draw_shapes.py   — Python node: draws a square with the turtle"
	@echo "  examples/multi_turtle.sh  — spawns 3 turtles at different positions"
	@echo "  examples/hello_ros2.py    — minimal publisher/subscriber in Python"
	@echo "  examples/rosbag_record.sh — record and replay turtle movements"
	@echo ""
