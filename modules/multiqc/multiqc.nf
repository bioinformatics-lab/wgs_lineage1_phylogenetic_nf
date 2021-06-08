nextflow.enable.dsl = 2

process MULTIQC {
    publishDir params.resultsDir, mode: params.saveMode, enabled: params.shouldPublish

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
