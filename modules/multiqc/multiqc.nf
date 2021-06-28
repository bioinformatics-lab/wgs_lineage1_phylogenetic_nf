nextflow.enable.dsl = 2

process MULTIQC_ORIGINAL {
    publishDir "${params.results_dir}/multiqc/original", mode: params.save_mode, enabled: params.should_publish

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
