"""
Run this script above the src/ folder to zip the game into an app.love file.
Usage: `$ python makelove.py`
"""

import os
from subprocess import run

shell = os.getenv('SHELL')

run([shell, '-i', '-c', 'cd src; zip -r ../app.love *; cd ..'])
