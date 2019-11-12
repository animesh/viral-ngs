import "tasks_taxon_filter.wdl" as taxon_filter
import "tasks_assembly.wdl" as assembly

workflow assemble_denovo_bulk {
  
  Array[File] reads_unmapped_bams
  
  scatter(reads_unmapped_bam in reads_unmapped_bams) {
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
  }
}