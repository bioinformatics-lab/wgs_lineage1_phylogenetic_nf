// NOTE: To properly setup the gatk inside the docker image
// - Download the gatk-3.8.0 tar file from here https://console.cloud.google.com/storage/browser/gatk-software/package-archive/gatk;tab=objects?prefix=&forceOnObjectsSortingFiltering=false
// - tar -xvf GATK_TAR_FILE
// - gatk-register gatk_folder/gatk_jar

nextflow.enable.dsl = 2

process MTBSEQ_PER_SAMPLE {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/mtbseq_per_sample", pattern: "${genomeName}_results", mode: params.saveMode, enabled: params.shouldPublish
    // TODO port to errorStrategy and maxRetries
    // validExitStatus 0, 1, 2


    input:
    tuple val(genomeName), path("${genomeName}_${params.mtbseq_library_name}_R?.fastq.gz")
    path(gatk_jar)
    env USER

    output:
    val("${genomeName}") // Genome name
    path("""${genomeName}_results""") // Folder
    path("""${genomeName}_results/Called/*tab""")
    path("""${genomeName}_results/Position_Tables/*tab""")

    script:
    """
    set +e

    gatk-register ${gatk_jar}

    mkdir ${genomeName}_results

    MTBseq --step TBfull --thread ${task.cpus}

    mv  Amend ./${genomeName}_results/
    mv  Bam ./${genomeName}_results/
    mv  Called ./${genomeName}_results/
    mv  Classification ./${genomeName}_results/
    mv  GATK_Bam ./${genomeName}_results/
    mv  Groups ./${genomeName}_results/
    mv  Joint ./${genomeName}_results/
    mv  Mpileup ./${genomeName}_results/
    mv  Position_Tables ./${genomeName}_results/
    mv  Statistics ./${genomeName}_results/
    """

    stub:
    """
    echo "MTBseq --step TBfull --thread ${task.cpus}"
    mkdir ${genomeName}_results
    mkdir ${genomeName}_results/Called -p
    touch ${genomeName}_results/Called/${genomeName}_somelib.gatk_position_uncovered_cf4_cr4_fr75_ph4_outmode000.tab
    touch ${genomeName}_results/Called/${genomeName}_somelib.gatk_position_variants_cf4_cr4_fr75_ph4_outmode000.tab

    mkdir ${genomeName}_results/Position_Tables -p
    touch ${genomeName}_results/Position_Tables/${genomeName}_somelib.gatk_position_table.tab
    """

}

process MTBSEQ_COHORT {
    publishDir "${params.resultsDir}/mtbseq_cohort", mode: params.saveMode, enabled: params.shouldPublish
    // TODO port to errorStrategy and maxRetries
    // validExitStatus 0, 1, 2

    input:
    path(samples_tsv_ch)
    path("Called/*")
    path("Position_Tables/*")
    path(gatk_jar)
    env USER

    output:
    tuple path("Joint"), path("Amend"), path("Groups")

    script:

    """
    set +e
    gatk-register ${gatk_jar}
    export USER=$USER
    mkdir Joint && MTBseq --step TBjoin --samples ${samples_tsv_ch} --project ${params.mtbseq_project_name}
    mkdir Amend && MTBseq --step TBamend --samples ${samples_tsv_ch} --project ${params.mtbseq_project_name}
    mkdir Groups && MTBseq --step TBgroups --samples ${samples_tsv_ch} --project ${params.mtbseq_project_name}
    """

    stub:

    """
    mkdir Joint Amend Groups
    """

}
