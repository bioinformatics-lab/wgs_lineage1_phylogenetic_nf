/*
================================
params
================================
*/

params.resultsDir = 'results/mozGenomes'
// we can obtain this key from the NCBI portal
params.apiKey = "FIXME"

/*
================================
ids of genomes to be downloaded
================================
*/


ids = ['SAMEA5938985',
'SAMEA5938988',
'SAMEA5938989',
'SAMEA104708046',
'SAMEA5938977'
]

  

/*
================================
only for publishing these files to results folder
================================
*/


process downloadRawGenomes {

    input:
    set genomeName, file(genomeReads) from Channel.fromSRA(ids, cache: true, apiKey: params.apiKey)

    errorStrategy 'ignore'

    script:
    
    """
    mkdir -p ../../../$params.resultsDir
    mv \$(readlink -f ${genomeReads[0]}) ../../../$params.resultsDir/
    mv \$(readlink -f ${genomeReads[1]}) ../../../$params.resultsDir/

    """


}

