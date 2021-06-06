// based on https://github.com/nf-modules/fastqc
nextflow.enable.dsl = 2

process FASTQC {
    publishDir "${params.resultsDir}/fastqc/original/", mode: params.saveMode
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple file('*.html'), file('*.zip')


    script:

    """
    fastqc *fastq*
    """
}
