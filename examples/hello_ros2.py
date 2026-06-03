#!/usr/bin/env python3
"""
Minimal ROS2 publisher + subscriber in Python.
A starting point for your own ROS2 nodes.

Run in one terminal:   python3 examples/hello_ros2.py
"""
import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import threading
import time


class Talker(Node):
    def __init__(self):
        super().__init__('talker')
        self.pub = self.create_publisher(String, 'chatter', 10)
        self.count = 0
        self.timer = self.create_timer(1.0, self.publish)

    def publish(self):
        msg = String()
        msg.data = f'Hello ROS2! count={self.count}'
        self.pub.publish(msg)
        self.count += 1


class Listener(Node):
    def __init__(self):
        super().__init__('listener')
        self.sub = self.create_subscription(String, 'chatter', self.callback, 10)

    def callback(self, msg):
        print(f'  [Listener] received: "{msg.data}"')


def spin(node):
    rclpy.spin(node)


def main():
    rclpy.init()
    talker = Talker()
    listener = Listener()

    print('\nROS2 Hello World — Talker publishes every second, Listener prints it.')
    print('Press Ctrl+C to stop.\n')

    t1 = threading.Thread(target=spin, args=(talker,), daemon=True)
    t2 = threading.Thread(target=spin, args=(listener,), daemon=True)
    t1.start()
    t2.start()

    try:
        while True:
            time.sleep(0.1)
    except KeyboardInterrupt:
        pass
    finally:
        talker.destroy_node()
        listener.destroy_node()
        rclpy.shutdown()
        print('\nShutdown complete.')


if __name__ == '__main__':
    main()
