nextflow.enable.dsl = 2

include {EXPORT_RAW_GENOMES} from "./modules/export_raw_genomes/export_raw_genomes.nf"
include {TRIMMOMATIC} from "./modules/trimmomatic/trimmomatic.nf"
include {FASTQC as FASTQC_ORIGINAL} from "./modules/fastqc/fastqc.nf"
include {FASTQC as FASTQC_TRIMMED} from "./modules/fastqc/fastqc.nf"
include {SPADES} from "./modules/spades/spades.nf"
include {MTBFULL} from "./modules/mtbseq/mtbseq.nf"
include {PROKKA} from "./modules/prokka/prokka.nf"
include {TBPROFILLER} from "./modules"

workflow {
	sra_ch = Channel.fromSRA(params.genomeIds, cache: true, apiKey: params.apiKey)
	EXPORT_RAW_GENOMES(sra_ch)
	FASTQC_ORIGINAL(sra_ch)
	TRIMMOMATIC(sra_ch)
	FASTQC_TRIMMED(TRIMMOMATIC.out.trimmed_reads)
	SPADES(TRIMMOMATIC.out.spades_reads)
	MTBFULL(TRIMMOMATIC.out.mtbseq)
	RDANALYZER(TRIMMOMATIC.out.)
	PROKKA(SPADES.out.prokka_contigs)

}
