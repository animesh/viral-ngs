version 1.0

import "tasks_demux.wdl" as demux

workflow merge_bams {
    call demux.merge_and_reheader_bams
}
