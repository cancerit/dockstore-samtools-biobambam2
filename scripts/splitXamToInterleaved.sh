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

export REF_PATH="URL=$ref_path" # 'URL=https://www.ebi.ac.uk/ena/cram/md5/%s'
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
disablevalidation=1 \
inputformat=bam > /dev/null

EXPECT_DEFAULT=${output_prefix}_default_i.fq.gz

add_default=''

if [ -e $EXPECT_DEFAULT ]; then
  add_default='@RG\tID:default'
fi

## Generate RG json file. In the format (unordered):
#        [
#            {"LB": "", "PU": "", ... },
#            {"ID": "", "PU": "", ...},
#        ]

(echo -e $add_default ; samtools view -H $xam_in) | \
grep -e '^@RG' | \
perl -e 'use JSON; @store = (); @wanted = ( "ID", "BC", "CN", "DT", "FO", "KS", "LB", "PI", "PL", "PM", "PU"  ); while(<>) {$line=$_; chomp($line); $line=~s/(\@RG\t)//; @arr=split("\t",$line); my %ha= map { split(":", $_, 2) } @arr; foreach $ky(keys %ha){if(!grep (/$ky/, @wanted) ) {delete $ha{$ky};} $cp = \%ha; } push (@store, $cp); } $json = encode_json(\@store); print $json,"\n"' > $rg_info_out
