nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/rd_analyzer"
params.save_mode = 'copy'
params.should_publish = true

process RD_ANALYZER {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish


    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple path("*result"), path("*depth")


    script:

    """
    python  /RD-Analyzer/RD-Analyzer.py  -o ${genomeName} ${genomeReads[0]} ${genomeReads[1]}
    """

    stub:
    """
    echo "python /RD-Analyzer/RD-Analyzer.py -o ${genomeName} ${genomeReads[0]} ${genomeReads[1]}"

    touch ${genomeName}.result
    touch ${genomeName}.depth
    """

}
