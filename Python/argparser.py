import argparse

global usage

usage = '''

GitHub Enterprise management utility

My app

script.py

'''

parser = argparse.ArgumentParser(description=f'{usage}')
parser.add_argument('environment', type=str, help='Environment in which to run. Either prod or dev')
args = parser.parse_args()
environment = args.environment.lower()
print(f"\n Environment selected is: {environment}")
