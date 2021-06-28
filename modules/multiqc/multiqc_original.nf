nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/raw_genomes"
params.save_mode = 'copy'
params.should_publish = true

process MULTIQC_ORIGINAL {
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    path("*")

    output:
    tuple path("""multiqc_data"""),
            path("""multiqc_report.html""")


    script:

    """
    multiqc .
    """

    stub:
    """
    mkdir multiqc_data

    touch multiqc_report.html
    """
}

process MULTIQC_TRIMMED {
    publishDir "${params.results_dir}/multiqc/trimmed", mode: params.save_mode, enabled: params.should_publish

    input:
    file("*")

    output:
    tuple path("""multiqc_data"""),
            path("""multiqc_report.html""")


    script:

    """
    multiqc .
    """

    stub:
    """
    mkdir multiqc_data

    touch multiqc_report.html
    """
}
