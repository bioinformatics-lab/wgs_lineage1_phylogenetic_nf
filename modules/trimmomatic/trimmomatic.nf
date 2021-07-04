// based on https://github.com/nf-modules/trimmomatic.git
nextflow.enable.dsl =2

params.results_dir = "${params.outdir}/trimmomatic"
params.save_mode = 'copy'
params.should_publish = true

process TRIMMOMATIC {
    tag "${genomeName}"
    publishDir params.results_dir, mode: params.save_mode, enabled: params.should_publish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), path("*_{R1,R2}.p.fastq.gz"), emit: trimmed_reads

    script:

    fq_1_paired = genomeName + '_R1.p.fastq.gz'
    fq_1_unpaired = genomeName + '_R1.s.fastq.gz'
    fq_2_paired = genomeName + '_R2.p.fastq.gz'
    fq_2_unpaired = genomeName + '_R2.s.fastq.gz'

    def adapterFile = "/usr/local/share/trimmomatic-0.35-6/adapters/${params.adapter_file_name}"

    """
    trimmomatic \
    PE \
    -threads ${task.cpus} \
    -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    ILLUMINACLIP:${adapterFile}:2:40:15  \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:3:28 HEADCROP:20 MINLEN:40
    """

    stub:
    fq_1_paired = genomeName + '_R1.p.fastq.gz'
    fq_1_unpaired = genomeName + '_R1.s.fastq.gz'
    fq_2_paired = genomeName + '_R2.p.fastq.gz'
    fq_2_unpaired = genomeName + '_R2.s.fastq.gz'

    def adapterFile = "/usr/local/share/trimmomatic-0.35-6/adapters/${params.adapter_file_name}"

    """
    echo "trimmomatic \
    PE \
    -threads ${task.cpus} \
    -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    ILLUMINACLIP:${adapterFile}:2:40:15  \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:3:28 HEADCROP:20 MINLEN:40"

    touch ${genomeName}_R1.p.fastq.gz
    touch ${genomeName}_R2.p.fastq.gz

    """
}

