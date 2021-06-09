//based on https://github.com/nf-modules/spotyping/blob/master/main.nf
nextflow.enable.dsl = 2

process SPOTYPING {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/spotyping", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple file('*.txt'), file('SITVIT*.xls')

    script:
    genomeReadToBeAnalyzed = params.R2 ? genomeReads[1] : genomeReads[0]

    """
    python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReadToBeAnalyzed} -o ${genomeFileName}.txt
    """

    stub:
    genomeReadToBeAnalyzed = params.R2 ? genomeReads[1] : genomeReads[0]
    """
    echo "python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReadToBeAnalyzed} -o ${genomeName}.txt"
    touch ${genomeName}.txt
    touch SITVIT_${genomeName}.xls
    """

}
