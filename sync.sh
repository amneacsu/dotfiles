#!/bin/bash

rsync ./ ~/ --exclude-from=.rsync-exclude --recursive --verbose
