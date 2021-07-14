nextflow.enable.dsl = 2

include { EXPORT_RAW_GENOMES } from "./modules/export_raw_genomes/export_raw_genomes.nf"
include { MTBSEQ_PER_SAMPLE } from "./modules/mtbseq/mtbseq_per_sample.nf"
include { MTBSEQ_COHORT } from "./modules/mtbseq/mtbseq_cohort.nf"
// include { FASTQC as FASTQC_ORIGINAL } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc/original")
// include { FASTQC as FASTQC_TRIMMED } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc/trimmed")
// include { MULTIQC as MULTIQC_ORIGINAL } from "./modules/multiqc/multiqc.nf" addParams(resultsDir: "${params.outdir}/multiqc/original")
// include { MULTIQC as MULTIQC_TRIMMED } from "./modules/multiqc/multiqc.nf" addParams(resultsDir: "${params.outdir}/multiqc/trimmed")
// include { SPADES } from "./modules/spades/spades.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { RD_ANALYZER } from "./modules/rd_analyzer/rd_analyzer.nf"

include { SPOTYPING } from "./modules/spotyping/spotyping.nf"
include { TBPROFILER_COLLATE } from "./modules/tbprofiler/collate.nf"
include { TBPROFILER_PROFILE } from "./modules/tbprofiler/profile.nf"
include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"

workflow {

// Data Input
    if (params.input_type == "reads") {
        input_ch = Channel.fromFilePairs(params.reads,checkIfExists: true)}

    if (params.input_type == "sra") {
        input_ch = Channel.fromSRA(params.genome_ids, cache: true, apiKey: params.api_key)}


// Export Genomes
    EXPORT_RAW_GENOMES(input_ch)
    
 // NOTE: Not used in publication
 // Quality control
 //    FASTQC_ORIGINAL(input_ch)
 //    MULTIQC_ORIGINAL(FASTQC_ORIGINAL.out.flatten().collect())

   TRIMMOMATIC(input_ch)


//	Analysis

// TODO: Rewrite this using a sub-workflow
    MTBSEQ_PER_SAMPLE(TRIMMOMATIC.out.trimmed_reads,params.gatkjar,params.USER)

    samples_tsv_file = MTBSEQ_PER_SAMPLE.out[0]
            .collect()
            .flatten().map { n -> "$n" + "\t" + "${params.mtbseq_library_name}" + "\n" }
            .collectFile(name: 'samples.tsv', newLine: false, storeDir: "${params.outdir}/mtbseq/cohort")

    MTBSEQ_COHORT(
            samples_tsv_file,
            MTBSEQ_PER_SAMPLE.out[2].collect(),
            MTBSEQ_PER_SAMPLE.out[3].collect(),
            params.gatkjar,
            params.USER)

// NOTE: Not used in publication
//    FASTQC_TRIMMED(TRIMMOMATIC.out.trimmed_reads)
//    MULTIQC_TRIMMED(FASTQC_TRIMMED.out.flatten().collect())
//    SPADES(TRIMMOMATIC.out.trimmed_reads)
//    PROKKA(SPADES.out.prokka_contigs,params.reference)

SPOTYPING(TRIMMOMATIC.out.trimmed_reads)
    TBPROFILER_PROFILE(TRIMMOMATIC.out.trimmed_reads)
    TBPROFILER_COLLATE(TBPROFILER_PROFILE.out[1].flatten().collect())
    RD_ANALYZER(TRIMMOMATIC.out.trimmed_reads)


}
