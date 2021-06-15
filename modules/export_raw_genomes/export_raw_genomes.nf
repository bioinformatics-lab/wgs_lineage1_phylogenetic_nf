nextflow.enable.dsl = 2

process EXPORT_RAW_GENOMES {
	publishDir "${params.resultsDir}", mode: params.saveMode
	errorStrategy 'ignore'

    input:
    path(genomeReads)

    output:
    path("raw_genomes")

    script:
    """
    mkdir raw_genomes
    mv *.fastq.gz raw_genomes/.
    """

    stub:
    """
    """

}
