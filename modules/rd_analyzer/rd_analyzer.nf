nextflow.enable.dsl = 2

process RD_ANALYZER {
    tag "${genomeName}"
    publishDir "${params.results_dir}/rd_analyzer", mode: params.save_mode, enabled: params.should_publish


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
