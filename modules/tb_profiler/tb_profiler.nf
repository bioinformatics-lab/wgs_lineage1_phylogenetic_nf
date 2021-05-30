//based on https://github.com/nf-modules/tb-profiler/blob/master/main.nf
nextflow.enable.dsl = 2

process TBPROFILER {
    /*
     The downstream process `tb-profiler collate` expects all individual results to be in
     a folder called results
     */
    publishDir """${params.resultsDir}/results""", mode: params.saveMode
    container 'quay.io/biocontainers/tb-profiler:2.8.6--pypy_0'

    when:
    !params.collate

    input:
    tuple genomeName, file(genomeReads) from ch_in_tbProfiler

    output:
    tuple path("""${genomeName}.results.txt"""),
                 path("""${genomeName}.results.json""") into ch_out_tbProfiler


    script:

    """
    tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t 4 -p $genomeName --txt
    cp results/* ./
    """

}


process TBPROFILER_COLLATE {
    publishDir './', mode: params.saveMode
    container 'quay.io/biocontainers/tb-profiler:2.8.6--pypy_0'

    echo true

    when:
    params.collate

    input:
    path("""${params.resultsDir}/results""") from ch_in_tbProfiler_collate

    output:
    tuple file("""${params.resultsDir}/tbprofiler.dr.indiv.itol.txt"""),
            file("""${params.resultsDir}/tbprofiler.dr.itol.txt"""),
            file("""${params.resultsDir}/tbprofiler.json"""),
            file("""${params.resultsDir}/tbprofiler.lineage.itol.txt"""),
            file("""${params.resultsDir}/tbprofiler.txt"""),
            file("""${params.resultsDir}/tbprofiler.variants.txt""") into ch_out_tbProfiler_collate


    script:

    """
    cd $params.resultsDir
    tb-profiler update_tbdb
    tb-profiler collate
    """

}
