import "tasks_reports.wdl" as reports

workflow improv_report {
   call reports.assembly_improvability_report {
   }
   meta {
       description: "Compute assembly improvability metrics"
   }
}

