nextflow.enable.dsl = 2

process EXPORT_RAW_GENOMES {
    tag "${genomeName}"
    publishDir "${params.results_dir}/raw_genomes", mode: params.save_mode
    errorStrategy 'ignore'

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    path(genomeReads)

    script:
    """
    """

    stub:
    """
    """

}
