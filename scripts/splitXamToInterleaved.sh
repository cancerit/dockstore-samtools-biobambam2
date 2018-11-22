#! /bin/bash

#####
#
# Script to take bam/cram input and convert to interleaved fastq
#
#####

set -ue
set -o pipefail

if [ "$#" -lt "4" ] ; then
  echo "Please provide an input xam path, prefix (to all output files), cram reference, output RG info json filename."
  exit 1
fi


xam_in=$1
output_prefix=$2
ref_path=$3
rg_info_out=$4

## Generate RG json file. In the format (unordered): 
#        [
#            {"LB": "", "PU": "", ... },
#            {"ID": "", "PU": "", ...},
#        ]

samtools view -H $xam_in | \
grep -e '^@RG' | \
perl -e 'use JSON; @store = (); @wanted = ( "ID", "BC", "CN", "DT", "FO", "KS", "LB", "PI", "PL", "PM", "PU"  ); while(<>) {$line=$_; chomp($line); $line=~s/(\@RG\t)//; @arr=split("\t",$line); my %ha= map { split(":", $_, 2) } @arr; foreach $ky(keys %ha){if(!grep (/$ky/, @wanted) ) {delete $ha{$ky};} $cp = \%ha; } push (@store, $cp); } $json = encode_json(\@store); print $json,"\n"' > $rg_info_out

export REF_PATH=$ref_path #'URL=https://www.ebi.ac.uk/ena/cram/md5/%s'
export REF_CACHE="$PWD/hts-ref-cache/%2s/%2s/%s"
mkdir -p $PWD/hts-ref-cache

samtools view -F 2304 -bu $xam_in | \
bamtofastq \
gz=1 \
exclude=SECONDARY,SUPPLEMENTARY \
tryoq=1 \
outputperreadgroup=1 \
outputperreadgroupprefix=$output_prefix \
outputperreadgroupsuffixF=_i.fq.gz \
outputperreadgroupsuffixF2=_i.fq.gz \
outputperreadgroupsuffixO=_o.fq.gz \
outputperreadgroupsuffixO2=_o.fq.gz \
outputperreadgroupsuffixS=_s.fq.gz \
inputformat=bam \
