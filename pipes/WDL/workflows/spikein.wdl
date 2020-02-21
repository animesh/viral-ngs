version 1.0

import "tasks_reports.wdl" as reports

workflow spikein {
    call reports.spikein_report
}
