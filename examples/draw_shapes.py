#!/usr/bin/env python3
"""
Draw shapes with the turtlesim turtle using ROS2 Python (rclpy).
Run: python3 examples/draw_shapes.py   (with ros2 env activated)
"""
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import time
import math


class TurtleDrawer(Node):
    def __init__(self):
        super().__init__('turtle_drawer')
        self.pub = self.create_publisher(Twist, '/turtle1/cmd_vel', 10)

    def move(self, linear=0.0, angular=0.0, duration=1.0):
        msg = Twist()
        msg.linear.x = float(linear)
        msg.angular.z = float(angular)
        end = time.time() + duration
        while time.time() < end:
            self.pub.publish(msg)
            time.sleep(0.05)

    def stop(self):
        self.move(0.0, 0.0, 0.2)

    def draw_square(self, side=2.0):
        print('Drawing a square...')
        for _ in range(4):
            self.move(linear=2.0, duration=side / 2.0)
            self.stop()
            self.move(angular=math.pi / 2, duration=1.0)
            self.stop()

    def draw_circle(self, speed=1.5, duration=6.0):
        print('Drawing a circle...')
        self.move(linear=speed, angular=speed, duration=duration)
        self.stop()

    def draw_spiral(self, steps=20):
        print('Drawing a spiral...')
        for i in range(1, steps):
            self.move(linear=0.2 + i * 0.1, angular=0.8, duration=0.3)
        self.stop()


def main():
    rclpy.init()
    node = TurtleDrawer()

    print('\nTurtle Drawer — starting in 2 seconds...')
    time.sleep(2)

    node.draw_circle()
    time.sleep(1)
    node.draw_square()
    time.sleep(1)
    node.draw_spiral()

    print('Done!')
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
