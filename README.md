# dockstore-samtools-biobambam2

A Docker and Dockstore wrapper for the samtools biobambam2 operations. Specifically converting xam to interleeaved fastqs by readgroup.

[![Docker Repository on Quay](https://quay.io/repository/wtsicgp/dockstore-samtools-biobambam2/status "Docker Repository on Quay")](https://quay.io/repository/wtsicgp/dockstore-samtools-biobambam2)

[![Build Status](https://travis-ci.org/cancerit/dockstore-samtools-biobambam2.svg?branch=master)](https://travis-ci.org/cancerit/dockstore-samtools-biobambam2) : master
[![Build Status](https://travis-ci.org/cancerit/dockstore-samtools-biobambam2.svg?branch=develop)](https://travis-ci.org/cancerit/dockstore-samtools-biobambam2) : develop

<!-- TOC depthFrom:1 -->

* [Input and Output](#input-and-output)
    * [inputs](#inputs)
    * [outputs](#outputs)
* [examples](#examples)

<!-- /TOC -->

## Input and Output

Please see `examples/*.json` for example json files for use with dockstore.

### inputs

- `xam_in` - [B|Cr]am file to be processed
- `rg_info_out` - Name of file to output the read group info `json` file.
  - defaults to `rg_info.json`
- `output_prefix` - Prepended to the output `.fq.gz` files.
  - defaults to `rg_split`
- `ref_path` - Cram reference location path
  - defaults to `https://www.ebi.ac.uk/ena/cram/md5/%s`

Other input options defined in the cwl should not be defined in the json file by users.

### outputs

- `ifastqs_out` - Gzipped interleaved fastq files named `$prefix_RG-ID_i.fq.gz` .
- `rg_info_json` - json file named as per `$rg_info_out`. Contains an array of tags found in the @RG lines. Split by RG.

## examples

There is one example included in this repository.

`examples/test.json` - runs the `splitXamToInterleaved.sh` script

- inputs:
  - A single bam file is presented as input
- Outputs:
  - The json rg info file
  - An intereleaved gzipped fastq file per read group

----

```bash
LICENCE

Copyright (c) 2018 Genome Research Ltd.

Author: Cancer, Ageing and Somatic Mutation, Wellcome Sanger Institute <cgpit@sanger.ac.uk>

This file is part of dockstore-samtools-biobambam2.

dockstore-samtools-biobambam2 is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation; either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

1. The usage of a range of years within a copyright statement contained within
this distribution should be interpreted as being equivalent to a list of years
including the first and last year specified and all consecutive years between
them. For example, a copyright statement that reads ‘Copyright (c) 2005, 2007-
2009, 2011-2012’ should be interpreted as being identical to a statement that
reads ‘Copyright (c) 2005, 2007, 2008, 2009, 2011, 2012’ and a copyright
statement that reads ‘Copyright (c) 2005-2012’ should be interpreted as being
identical to a statement that reads ‘Copyright (c) 2005, 2006, 2007, 2008,
2009, 2010, 2011, 2012’."
```
