// based on https://github.com/nf-modules/spades/
nextflow.enable.dsl = 2

params.results_dir = "${params.outdir}/spades"
params.save_mode = 'copy'
params.should_publish = true

process SPADES {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("*_contigs.fasta"), emit: prokka_contigs


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}
    cp ${genomeName}/contigs.fasta ${genomeName}_contigs.fasta
    """

    stub:
    """
    echo  "spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}"

    touch ${genomeName}_contigs.fasta
    """
}
