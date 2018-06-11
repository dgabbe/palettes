#! /usr/bin/env python3

# working from
# * http://inventwithpython.com/blog/2012/04/06/stop-using-print-for-debugging-a-5-minute-quickstart-guide-to-pythons-logging-module/
# * https://docs.python.org/3/howto/logging.html#a-simple-example

import getpass
import logging
import os
import platform
import string
import sys


def log_config(home = os.environ["HOME"]):
    """Unique name by machine and user.
    OS X: ~/Library/Logs/<machine-name>_<username>.log

    :param home:
    :return: log file name
    """
    machine_user = str.split(platform.uname()[1], ".local")[0] \
        + "_" + os.getlogin()
    log_file_path = os.path.join(home, "Library/Logs/")
    if not os.path.isdir(log_file_path):
        log_file_path = home

    l_file = log_file_path + machine_user + ".log"

    logging.basicConfig(
      filename=l_file,
      format='%(asctime)s %(filename)s %(levelname)s: %(message)s',
      datefmt='%m/%d/%Y %H:%M:%S',
      level=logging.INFO
    )
    return l_file

def log_start():
  logging.info(repo_dir + ": Start")

def log_end(f):
  logging.info(repo_dir + ": End")
  print("\nActions recorded in ", f, ".", sep = "")

def log_info(msg, indent = '\n    '):
  print(indent + msg, sep = "")
  logging.info(msg)

def log_warning(msg, indent = '\n    '):
  print(indent + msg, sep = "")
  logging.warning(msg)

def log_error(msg, indent = '\n    '):
  print(indent + msg, sep = "")
  logging.error(msg)

#
# Setup
#
home = os.environ["HOME"]
repo_installer = os.path.abspath(__file__)
repo_dir = os.path.dirname(repo_installer)
log_file = log_config()

#
# Start install
#
log_start()

try:
  import install_list
except:
  log_error("install_list.py not found!")
  log_end(log_file)
  sys.exit(1)

if len(install_list.scripts) == 0:
  log_error("Oops: install_lists.scripts length is 0")
  log_end(log_file)
  sys.exit(1)


for s in install_list.scripts:
  if len(s) != 2:
    log_warning("Skipping " + str(s) + ". Expected list like ['file', 'repo-file'].")
    continue

  f = os.path.join(home, s[0])
  repo_f = os.path.join(repo_dir, s[1])

  if not os.path.isfile(repo_f):
    log_warning(repo_f + " does not exist. Check for typo in install_list.py")
    continue
  else:
    try:
      os.symlink(repo_f, f)
      log_info(f + " -> " + os.path.realpath(f))
    except FileExistsError:
      log_warning("Skipping " + f + ". File or symlink already exists.")

log_end(log_file)


# Revisit if this code will work on python (v2) as well
# Lookup Python code documentation generator
