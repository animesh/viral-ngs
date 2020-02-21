version 1.0

import "tasks_taxon_filter.wdl" as taxon_filter
import "tasks_assembly.wdl" as assembly
import "tasks_reports.wdl" as reports

workflow assemble_denovo {

  input {
    File reads_unmapped_bam
    File   lastal_db_fasta
    Boolean run_optimality_report = false
  }

  call taxon_filter.filter_to_taxon {
    input:
      reads_unmapped_bam = reads_unmapped_bam,
      lastal_db_fasta = lastal_db_fasta
  }

  call assembly.assemble {
    input:
      reads_unmapped_bam = filter_to_taxon.taxfilt_bam
  }

  call assembly.scaffold {
    input:
      contigs_fasta = assemble.contigs_fasta,
      reads_bam = filter_to_taxon.taxfilt_bam
  }

  call assembly.refine_2x_and_plot {
    input:
      assembly_fasta = scaffold.scaffold_fasta,
      reads_unmapped_bam = reads_unmapped_bam
  }

  if (run_optimality_report) {
    call reports.assembly_optimality_report {
      input:
        taxon_refs_fasta = lastal_db_fasta,

	cleaned_reads_bam = reads_unmapped_bam,
	taxfilt_reads_bam = filter_to_taxon.taxfilt_bam,

	subsamp_reads_bam = assemble.subsampBam,
        contigs_fasta = assemble.contigs_fasta,

	intermediate_scaffold_fasta = scaffold.intermediate_scaffold_fasta,
	scaffold_fasta = scaffold.scaffold_fasta,
	
	refine1_assembly_fasta = refine_2x_and_plot.refine1_assembly_fasta,
        final_assembly_fasta = refine_2x_and_plot.final_assembly_fasta
    }
  }
}
