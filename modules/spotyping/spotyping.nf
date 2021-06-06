//based on https://github.com/nf-modules/spotyping/blob/master/main.nf
nextflow.enable.dsl = 2

process SPOTYPING {
    container 'abhi18av/spotyping'
    publishDir params.resultsDir, mode: params.saveMode

    input:
    tuple genomeName, file(genomeReads)

    output:
    tuple file('*.txt'),
            file('SITVIT*.xls')

    script:
    R2 = false
    genomeReadToBeAnalyzed = R2 ? genomeReads[1] : genomeReads[0]

    """
    python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReadToBeAnalyzed} -o ${genomeName}.txt
    """

}
