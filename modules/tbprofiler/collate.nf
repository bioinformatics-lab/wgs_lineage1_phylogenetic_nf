//based on https://github.com/nf-modules/tb-profiler/blob/master/main.nf
nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/tbprofiler/collate"
params.save_mode = 'copy'
params.should_publish = true


process TBPROFILER_COLLATE {
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    path("results/*")

    output:
    path("tbprofiler*")

    script:
    """
    tb-profiler update_tbdb
    tb-profiler collate
    cp tbprofiler.txt tbprofiler_cohort_report.tsv
    """

    stub:
    """
    touch tbprofiler_cohort_report.tsv
    """
}
