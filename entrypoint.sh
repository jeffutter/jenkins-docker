#!/bin/bash
set -e

source /etc/profile.d/rvm.sh

exec /bin/tini -- /usr/local/bin/jenkins.sh
