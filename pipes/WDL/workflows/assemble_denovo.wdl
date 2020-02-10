import "tasks_taxon_filter.wdl" as taxon_filter
import "tasks_assembly.wdl" as assembly
import "tasks_reports.wdl" as reports

workflow assemble_denovo {
  
  File reads_unmapped_bam

  call taxon_filter.filter_to_taxon {
    input:
      reads_unmapped_bam = reads_unmapped_bam
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

  call reports.compute_assembly_improvability_metrics {
    input:
      #raw_reads_bam = reads_unmapped_bam,
      taxon_refs_fasta = filter_to_taxon.lastal_db_fasta_out,
      contigs_fasta = assemble.contigs_fasta,
      assembly_fasta = refine_2x_and_plot.final_assembly_fasta
  }
}
