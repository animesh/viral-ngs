"""Unit tests for reports.py"""

__author__ = "dpark@broadinstitute.org, ilya@broadinstitute.org"

import reports
import util.cmd
import util.file
import Bio.SeqIO
import Bio.Data.IUPACData
import unittest
import argparse
import os
import os.path
import shutil
import tempfile
import argparse
import itertools
import pytest
from test import TestCaseWithTmp, _CPUS

def makeFasta(seqs, outFasta):
    with open(outFasta, 'wt') as outf:
        for line in util.file.fastaMaker(seqs):
            outf.write(line)


class TestCommandHelp(unittest.TestCase):

    def test_help_parser_for_each_command(self):
        for cmd_name, parser_fun in reports.__commands__:
            parser = parser_fun(argparse.ArgumentParser())
            helpstring = parser.format_help()

