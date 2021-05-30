//based on https://github.com/nf-modules/mtbseq/blob/develop/main.nf

process MTBFULL {
    publishDir "${params.resultsDir}/mtbseq/", mode: params.saveMode
//    container 'quay.io/biocontainers/mtbseq:1.0.4--1'
//    container 'quay.io/biocontainers/mtbseq:1.0.4--pl526_0'
//    container 'quay.io/biocontainers/mtbseq:1.0.3--pl526_1'
//    container 'conmeehan/mtbseq:version1'
    container 'arnoldliao95/mtbseq' 

    validExitStatus 0,1,2
    errorStrategy 'ignore'

    input:
    tuple genomeFileName, file(genomeReads)

    output:
    path("""${genomeFileName}""")

    script:

    """
    mkdir ${genomeFileName}
   
    perl /MTBseq_source/MTBseq.pl --step TBfull --thread 8
    
    cp -a Amend ./${genomeFileName}/
    cp -a Bam ./${genomeFileName}/
    cp -a Called ./${genomeFileName}/
    cp -a Classification ./${genomeFileName}/
    cp -a GATK_Bam ./${genomeFileName}/
    cp -a Groups ./${genomeFileName}/
    cp -a Joint ./${genomeFileName}/
    cp -a Mpileup ./${genomeFileName}/
    cp -a Position_Tables ./${genomeFileName}/
    cp -a Statistics ./${genomeFileName}/
    """

}
