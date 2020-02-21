version 1.0

import "tasks_reports.wdl" as reports

workflow assembly_optimality_report {
   call reports.assembly_optimality_report {
   }
   meta {
       description: "Compute assembly optimality metrics"
   }
}
