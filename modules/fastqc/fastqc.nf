// based on https://github.com/nf-modules/fastqc
nextflow.enable.dsl = 2

process FASTQC {
    tag "${genomeName}"
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple path('*.html'), path('*.zip')


    script:

    """
    fastqc *fastq*
    """

    stub:

    """
    echo "fastqc *fastq*"

    mkdir ${genomeName}
    touch ${genomeName}.html
    touch ${genomeName}.zip
    """
}
