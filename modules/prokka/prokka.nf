//based on https://github.com/nf-modules/prokka/blob/master/main.nf
nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/prokka"
params.save_mode = 'copy'
params.should_publish = true

process PROKKA {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

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
