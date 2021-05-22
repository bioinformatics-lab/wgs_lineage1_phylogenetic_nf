nextflow.enable.dsl = 2

process EXPORT_RAW_GENOMES {
	publishDir "${params.resultsDir}", mode: "copy", overwrite: true, pattern: "*.fastq.gz"
	errorStrategy 'ignore'

    input:
    set genomeName, file(genomeReads)

    output: 
    	file("*.fastq.gz")

    script:   
    """
    """

}
