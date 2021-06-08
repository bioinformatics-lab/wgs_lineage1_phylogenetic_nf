nextflow.enable.dsl = 2

include {EXPORT_RAW_GENOMES} from "./modules/export_raw_genomes/export_raw_genomes.nf"
include {TRIMMOMATIC} from "./modules/trimmomatic/trimmomatic.nf"
include {FASTQC as FASTQC_ORIGINAL} from "./modules/fastqc/fastqc.nf"
include {FASTQC as FASTQC_TRIMMED} from "./modules/fastqc/fastqc.nf"
include {SPADES} from "./modules/spades/spades.nf"
include {MTBSEQ_PER_SAMPLE} from "./modules/mtbseq/mtbseq.nf"
include {PROKKA} from "./modules/prokka/prokka.nf"
include {TBPROFILER_PROFILE} from "./modules/tb_profiller/tb_profiller.nf"

workflow {
	sra_ch = Channel.fromSRA(params.genomeIds, cache: true, apiKey: params.apiKey)
	EXPORT_RAW_GENOMES(sra_ch)
	FASTQC_ORIGINAL(sra_ch)
	TRIMMOMATIC(sra_ch)
	FASTQC_TRIMMED(TRIMMOMATIC.out.trimmed_reads)
	TBPROFILER_PROFILE(TRIMOMMATIC.out.trimmed_reads)
	SPADES(TRIMMOMATIC.out.trimmed_reads)
	MTBSEQ_PER_SAMPLE(TRIMMOMATIC.out./*FIXME*/,gatkjar_ch)
	RDANALYZER(TRIMMOMATIC.out.trimmed_reads)
	PROKKA(SPADES.out.prokka_contigs)

}
