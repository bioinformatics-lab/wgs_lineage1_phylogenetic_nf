nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/raw_genomes"
params.save_mode = 'copy'
params.should_publish = true

process EXPORT_RAW_GENOMES {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish
    errorStrategy 'ignore'

    when:
    params.export_genomes == true

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
