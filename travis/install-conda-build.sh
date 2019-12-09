#!/bin/bash

apt-get install -y -qq --no-install-recommends gcc
conda install -q -y -c broad-viral -c r -c bioconda -c conda-forge -c defaults conda-build==3.0.25 anaconda-client jinja2==2.8
