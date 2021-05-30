//based on https://github.com/nf-modules/rd-analyzer/blob/master/main.nf
nextflow.enable.dsl = 2

process RDANALYZER {
    container 'abhi18av/rdanalyzer'
    publishDir params.resultsDir, mode: params.saveMode

    input:
    tuple genomeFileName, file(genomeReads)

    output:
    tuple path("""${genomeName}.result"""), path("""${genomeName}.depth""")


    script:
    genomeName = genomeFileName.toString().split("\\_")[0]

    """
    python  /RD-Analyzer/RD-Analyzer.py  -o ./${genomeName} ${genomeReads[0]} ${genomeReads[1]}
    """
}
