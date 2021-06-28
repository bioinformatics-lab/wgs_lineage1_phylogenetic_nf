//based on https://github.com/nf-modules/tb-profiler/blob/master/main.nf
nextflow.enable.dsl = 2

process TBPROFILER_PROFILE {
    tag "${genomeName}"
    publishDir "${params.results_dir}/tb_profiler/profile", mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple path("results/*txt"), path("results/*json")
    path("results/*")

    script:
    """
    tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t ${task.cpus} -p ${genomeName} --txt
    """

    stub:
    """
    echo "tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t ${task.cpus} -p ${genomeName} --txt"

    mkdir results
    touch results/"${genomeName}.results.txt"
    touch results/"${genomeName}.results.json"
    """

}


process TBPROFILER_COLLATE {
    publishDir "${params.results_dir}/tb_profiler/collate", mode: params.save_mode, enabled: params.should_publish

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
