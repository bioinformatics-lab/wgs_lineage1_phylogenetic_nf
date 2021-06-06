//based on https://github.com/nf-modules/prokka/blob/master/main.nf
nextflow.enable.dsl = 2

/*
Old Inputs TODO

params.spadesResults = 'results/spades/*_scaffolds.fasta'
params.resultsDir = 'results/prokka'
params.saveMode = 'copy'

Channel.fromPath("""${params.spadesResults}""")
        .into { ch_in_prokka }
 */

process PROKKA {
    publishDir "${params.resultsDir}/prokka/", mode: params.saveMode
    container 'quay.io/biocontainers/prokka:1.14.6--pl526_0'

    input:
    tuple val(genomeName),file(assembly)

    output:
    path("${genomeName}")


    script:
    """
    prokka --outdir ./${genomeName} --prefix $genomeName ${assembly}
    """

}
