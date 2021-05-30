// based on https://github.com/nf-modules/trimmomatic.git
nextflow.enable.dsl =2

process TRIMOMMATIC {

    publishDir "${params.resultsDir}/trimmomatic/", mode: params.saveMode
    container 'quay.io/biocontainers/trimmomatic:0.35--6'

    input:
    tuple val(genomeName), file(genomeReads)
    output:
    tuple file(fq_1_paired),file(fq_2_paired), emit: trimmed_reads
    tuple val(genomeName), file(fq_1_paired),file(fq_2_paired), emit: spades_reads

    script:

    fq_1_paired = genomeName + '_R1.p.fastq'
    fq_1_unpaired = genomeName + '_R1.s.fastq'
    fq_2_paired = genomeName + '_R2.p.fastq'
    fq_2_unpaired = genomeName + '_R2.s.fastq'

    """
    trimmomatic \
    PE -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
    """
}

