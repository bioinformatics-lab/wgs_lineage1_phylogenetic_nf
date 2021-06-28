//based on https://github.com/nf-modules/prokka/blob/master/main.nf
nextflow.enable.dsl = 2

/*
Old Inputs TODO

params.spades_results = 'results/spades/*_scaffolds.fasta'
params.results_dir = 'results/prokka'
params.save_mode = 'copy'

Channel.fromPath("""${params.spades_results}""")
        .into { ch_in_prokka }
 */

process PROKKA {
    tag "${genomeName}"
    publishDir "${params.results_dir}/prokka", mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(bestContig)
    path(reference)

    output:
    path("${genomeName}")

    script:

    """
    prokka --outdir ${genomeName} --prefix ${genomeName} --cpus ${task.cpus} --proteins ${reference} --locustag ${genomeName} ${bestContig}
    """

    stub:

    """
    echo "prokka --outdir ${genomeName} --prefix $genomeName --cpus ${task.cpus} --proteins ${reference} --locustag ${genomeName} ${bestContig}"


    mkdir ${genomeName}

    """
}
