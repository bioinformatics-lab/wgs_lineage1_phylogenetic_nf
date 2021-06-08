//based on https://github.com/nf-modules/tb-profiler/blob/master/main.nf
nextflow.enable.dsl = 2

process TBPROFILER_PROFILE {
    publishDir params.resultsDir_tbprofiler_per_sample, mode: params.saveMode_tbprofiler_per_sample, enabled: params.shouldPublish_tbprofiler_per_sample

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple path("results/*txt"), path("results/*json")


    script:
    """
    tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t ${task.cpus} -p $genomeName --txt
    """

    stub:
    """
    echo "tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t ${task.cpus} -p $genomeName --txt"

    mkdir results
    touch results/"${genomeName}.results.txt"
    touch results/"${genomeName}.results.json"
    """

}


process TBPROFILER_COLLATE {
    publishDir params.resultsDir_tbprofiler_cohort, mode: params.saveMode_tbprofiler_cohort, enabled: params.shouldPublish_tbprofiler_cohort

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
