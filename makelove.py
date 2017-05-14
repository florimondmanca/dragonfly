import os
from subprocess import run

shell = os.getenv('SHELL')

run([shell, '-i', '-c', 'cd src; zip -r ../app.love *; cd ..'])
