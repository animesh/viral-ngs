import "tasks_taxon_filter.wdl" as taxon_filter
import "tasks_assembly.wdl" as assembly

workflow assemble_denovo_bulk {
  
  Array[File] reads_unmapped_bams
  
  scatter(reads_unmapped_bam in reads_unmapped_bams) {
    call taxon_filter.filter_to_taxon as taxon_filter {
    input:
      reads_unmapped_bam = reads_unmapped_bam
    }
    
    call assembly.assemble as assembleassemble {
    input:
      reads_unmapped_bam = taxon_filter.taxfilt_bam
    }
    
    call assembly.scaffold as scaffoldscaffold {
    input:
      contigs_fasta = assembleassemble.contigs_fasta,
      reads_bam = taxon_filter.taxfilt_bam
    }
    
    call assembly.refine_2x_and_plot as refine {
    input:
      assembly_fasta = scaffoldscaffold.scaffold_fasta,
      reads_unmapped_bam = reads_unmapped_bam
    }
  }
}