"""Unit tests for reports.py"""

__author__ = "dpark@broadinstitute.org, ilya@broadinstitute.org"

import unittest
import os
import os.path
import argparse
import functools
import json
import collections

import Bio.SeqIO
import Bio.Data.IUPACData

import util.cmd
import util.file
from test import TestCaseWithTmp, _CPUS
import reports

def _load_dict_sorted(d):
    return collections.OrderedDict(sorted(d.items()))

def _json_loads(s):
    return json.loads(s.strip(), object_hook=_load_dict_sorted, object_pairs_hook=collections.OrderedDict)

def _json_loadf(fname):
    return _json_loads(util.file.slurp_file(fname, maxSizeMb=1000))

def _pretty_print_json(json_dict, sort_keys=True):
    """Return a pretty-printed version of a dict converted to json, as a string."""
    return json.dumps(json_dict, indent=4, separators=(',', ': '), sort_keys=sort_keys)

def _write_json(fname, **json_dict):
    util.file.dump_file(fname=fname, value=_pretty_print_json(json_dict))

class TestCommandHelp(unittest.TestCase):

    def test_help_parser_for_each_command(self):
        for cmd_name, parser_fun in reports.__commands__:
            parser = parser_fun(argparse.ArgumentParser())
            helpstring = parser.format_help()

class TestAssemblyOptimalityReport:
    
    def test_assembly_optimality_report(self, tmp_path):

        def _inp(fname):
            """Return full path to a test input file for this module"""
            return os.path.join(util.file.get_test_input_path(self), fname)

        taxon_kmer_metrics_json = str(tmp_path / 'taxon_kmer_metrics.json')

        util.cmd.run_cmd(module=reports, cmd='assembly_optimality_report',
                         args=[_inp('hepatovirus_A_taxon_filter.fasta.gz'),
                               '--stage', '10_cleaned_reads', _inp('Hep_WGS19_270.bam'), '++minOccs', 2,
                               '--stage', '20_taxfilt_reads', _inp('Hep_WGS19_270.taxfilt.bam'), '++minOccs', 2,
                               '--stage', '30_contigs', _inp('Hep_WGS19_270.assembly1-trinity.fasta'),
                               '--stage', '40_intermediate_scaffold', _inp('Hep_WGS19_270.intermediate_scaffold.fasta'),
                               '--stage', '50_scaffold', _inp('Hep_WGS19_270.scaffolded_imputed.fasta'),
                               '--stage', '60_refine1_assembly', _inp('Hep_WGS19_270.refine1.fasta'),
                               '--stage', '90_final_assembly', _inp('Hep_WGS19_270.fasta'), '++cmpStages', '10_cleaned_reads',
                               '30_contigs',
                               '--outTaxonKmerMetricsJson', taxon_kmer_metrics_json])
        #_write_json(_inp('Hep_WGS19_270.taxon_kmer_metrics.expected.2.json'), **_json_loadf(taxon_kmer_metrics_json))
        assert _json_loadf(taxon_kmer_metrics_json) == \
            _json_loadf(_inp('Hep_WGS19_270.taxon_kmer_metrics.expected.json'))
