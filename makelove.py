"""
Run this script above the src/ folder to zip the game into an app.love file.
Usage: `$ python3 makelove.py`
"""

if __name__ == '__main__':
    import os
    from subprocess import run

    shell = os.getenv('SHELL')

    run([shell, '-i', '-c', 'cd src; zip -r ../app.love *; cd ..'])
