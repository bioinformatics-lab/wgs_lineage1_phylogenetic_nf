nextflow.enable.dsl = 2

include {EXPORT_RAW_GENOMES} from "./modules/export_raw_genomes/export_raw_genomes.nf"







workflow {
	sra_ch = Channel.fromSRA(params.genomeIds, cache: true, apiKey: params.apiKey)
	EXPORT_RAW_GENOMES(sra_ch)



}