nextflow.enable.dsl = 2

include {EXPORT_RAW_GENOMES} from "./modules/export_raw_genomes/export_raw_genomes.nf"
include {FASTQC_ORIGINAL} from "./modules/fastqc/fastqc.nf"
include {FASTQC_TRIMMED} from "./modules/fastqc/fastqc.nf"
include {MULTIQC_ORIGINAL} from "./modules/multiqc/multiqc.nf"
include {MULTIQC_TRIMMED} from "./modules/multiqc/multiqc.nf"
include {TRIMMOMATIC} from "./modules/trimmomatic/trimmomatic.nf"


include {SPADES} from "./modules/spades/spades.nf"
// include {MTBSEQ_PER_SAMPLE} from "./modules/mtbseq/mtbseq.nf"
include {PROKKA} from "./modules/prokka/prokka.nf"
include {TBPROFILER_PROFILE} from "./modules/tb_profiler/tb_profiler.nf"
include {TBPROFILER_COLLATE} from "./modules/tb_profiler/tb_profiler.nf"
include {SPOTYPING} from "./modules/spotyping/spotyping.nf"
include {RD_ANALYZER} from "./modules/rd_analyzer/rd_analyzer.nf"

workflow {

// Data Input
	sra_ch = Channel.fromSRA(params.genomeIds, cache: true, apiKey: params.apiKey)
//Export Genomes
	EXPORT_RAW_GENOMES(sra_ch)
// Quality control
	FASTQC_ORIGINAL(sra_ch)
	MULTIQC_ORIGINAL(FASTQC_ORIGINAL.out.flatten().collect())
	TRIMMOMATIC(sra_ch)
	FASTQC_TRIMMED(TRIMMOMATIC.out.trimmed_reads)
	MULTIQC_TRIMMED(FASTQC_TRIMMED.out.flatten().collect())
// Analysis
	TBPROFILER_PROFILE(TRIMMOMATIC.out.trimmed_reads)
	TBPROFILER_COLLATE(TBPROFILER_PROFILE.out[0].flatten().collect())
	SPOTYPING(TRIMMOMATIC.out.trimmed_reads)
	SPADES(TRIMMOMATIC.out.trimmed_reads)
//	MTBSEQ_PER_SAMPLE(TRIMMOMATIC.out./*FIXME*/,gatkjar_ch)
	RD_ANALYZER(TRIMMOMATIC.out.trimmed_reads)
	PROKKA(SPADES.out.prokka_contigs,Channel.fromPath(params.reference))

}
