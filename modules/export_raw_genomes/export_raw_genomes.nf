nextflow.enable.dsl = 2

process EXPORT_RAW_GENOMES {
	publishDir "${params.resultsDir}/raw_genomes", mode: params.saveMode
	errorStrategy 'ignore'

    input:
    path(genomeReads)

    output:
    path("*.fastq.gz")

    script:
    """
    """

    stub:
    """
    """

}
