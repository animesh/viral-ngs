#!/bin/bash

set -e -o pipefail

PYTHONPATH=$PWD PATH=$PWD/tools/git-annex-remotes:$PATH py.test "$@"



