nextflow.enable.dsl = 2

process RD_ANALYZER {
    tag "${genomeFileName}"
    publishDir "${params.resultsDir}/rd_analyzer", mode: params.saveMode, enabled: params.shouldPublish


    input:
    tuple val(genomeFileName), file(genomeReads)

    output:
    tuple path("*result"), path("*depth")


    script:

    """
    python  /RD-Analyzer/RD-Analyzer.py  -o ${genomeFileName} ${genomeReads[0]} ${genomeReads[1]}
    """

    stub:
    """
    echo "python /RD-Analyzer/RD-Analyzer.py -o ${genomeFileName} ${genomeReads[0]} ${genomeReads[1]}"

    touch ${genomeFileName}.result
    touch ${genomeFileName}.depth
    """

}
