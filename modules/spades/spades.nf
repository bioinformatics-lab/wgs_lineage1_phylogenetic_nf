// based on https://github.com/nf-modules/spades/
nextflow.enable.dsl = 2

process SPADES {
	tag "${genomeName}"
    container 'quay.io/biocontainers/spades:3.14.0--h2d02072_0'
    publishDir "${params.resultsDir}/spades/", mode: params.saveMode

    input:
    tuple val(genomeName), file(r1), file(r2)

    output:
    path """${genomeName}_scaffolds.fasta"""


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${r1} --pe1-2 ${r2} -o ${genomeName} -t 2
    cp ${genomeName}/scaffolds.fasta ${genomeName}_scaffolds.fasta 
    """
}
