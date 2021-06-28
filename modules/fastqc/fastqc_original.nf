// based on https://github.com/nf-modules/fastqc
nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/fastqc/original"
params.save_mode = 'copy'
params.should_publish = true

process FASTQC_ORIGINAL {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

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
