#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgp-xam-to-ifq"

label: "CGP [B|Cr]am to interleaved fastq by read group"

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-samtools-biobambam2:0.0.3"

inputs:
    xam_in:
        type: File
        doc: "Bam/Cram input file to be split into interleaved fastq split by read group"
        inputBinding:
            position: 1
            shellQuote: true

    output_prefix:
        type: string
        doc: "Prefix string to prepend to all output .fq.gz file names"
        default: "rg_split"
        inputBinding:
            position: 2
            shellQuote: true

    ref_path:
        type: string
        doc: "URL to use for cram reference e.g. 'https://www.ebi.ac.uk/ena/cram/md5/%s'"
        default: "https://www.ebi.ac.uk/ena/cram/md5/%s"
        inputBinding:
            position: 3
            shellQuote: true

    rg_info_out:
        type: string
        doc: "Filename for the json file containing RG info (ID, PU, CN, LB, DT tags)"
        default: "rg_info.json"
        inputBinding:
            position: 4
            shellQuote: true

outputs:
    ifastqs_out:
        type:
            type: array
            items: File
        doc: "Array of gzipped interleaved fastq output files. One per readgroup."
        outputBinding:
            glob: $(inputs.output_prefix)*_i.fq.gz

    rg_info_json:
        type: File
        doc: "json file containing RG line information"
        outputBinding:
            glob: $(inputs.rg_info_out)

baseCommand: ["splitXamToInterleaved.sh"]

doc: |
    ![build_status](https://quay.io/repository/wtsicgp/dockstore-samtools-biobambam2/status)
    A Docker container for samtools and biobambam operations. Script provided for xam to interleaved fastq.

    See the dockstore-samtools-biobambam2 [README](https://github.com/cancerit/dockstore-samtools-biobambam2/blob/develop/README.md)
    for full details of how to use.

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

s:codeRepository: https://github.com/cancerit/dockstore-samtools-biobambam2
s:license: https://spdx.org/licenses/AGPL-3.0

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0407-0386
    s:email: mailto:cgphelp@sanger.ac.uk
    s:name: David Jones
