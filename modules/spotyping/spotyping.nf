//based on https://github.com/nf-modules/spotyping/blob/master/main.nf
nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/spotyping"
params.save_mode = 'copy'
params.should_publish = true

process SPOTYPING {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple path('*.txt'), path('SITVIT*.xls')

    script:

    """
    python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReads[0]} ./${genomeReads[1]} -o ${genomeName}.txt
    """

    stub:
    """
    echo "python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReads[0]} ./${genomeReads[1]} -o ${genomeName}.txt"
    touch ${genomeName}.txt
    touch SITVIT_${genomeName}.xls
    """

}
