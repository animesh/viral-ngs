import "tasks_reports.wdl" as reports

workflow improv_metrics {
    meta {
       description: "Compute assembly improvability metrics"
    }

   call reports.compute_assembly_improvability_metrics {
   }
}

