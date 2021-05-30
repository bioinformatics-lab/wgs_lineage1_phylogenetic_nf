//based on https://github.com/nf-modules/spotyping/blob/master/main.nf
nextflow.enable.dsl = 2

process SPOTYPING {
    container 'abhi18av/spotyping'
    publishDir params.resultsDir, mode: params.saveMode

    input:
    tuple genomeFileName, file(genomeReads)

    output:
    tuple file('*.txt'),
            file('SITVIT*.xls')

    script:
    genomeName = genomeFileName.toString().split("\\_")[0]
    genomeReadToBeAnalyzed = params.R2 ? genomeReads[1] : genomeReads[0]

    """
    python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReadToBeAnalyzed} -o ${genomeName}.txt
    """

}
