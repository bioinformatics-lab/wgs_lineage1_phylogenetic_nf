// based on https://github.com/nf-modules/fastqc
nextflow.enable.dsl = 2

process FASTQC_ORIGINAL {
    tag "${genomeName}"
    publishDir "${params.results_dir}/fastqc/original", mode: params.save_mode, enabled: params.should_publish

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

process FASTQC_TRIMMED {
    tag "${genomeName}"
    publishDir "${params.results_dir}/fastqc/trimmed", mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple file('*.html'), file('*.zip')


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
