nextflow.enable.dsl = 2

process EXPORT_RAW_GENOMES {
	publishDir "${params.resultsDir}"
	errorStrategy 'ignore'

    input:
    set genomeName, file(genomeReads)

    output: 
    file(genomeReads)

    script:   
    """
    """

}
