#!/usr/bin/env bash

## 

## Get MSI (some aux scripts are needed)

## Do we have the data?
NFASTQ_FILES=$(ls -1 fastq/*.fastq.gz|wc -l)
if [ $NFASTQ_FILES == "0" ]; then
    echo "ERROR: .fastq.gz files not found in the folder fastq/. Please download and place them in the fastq/ folder"
    exit 1
fi

#################################################
## setup the environment

## Change to reflect that paths in your computer
THREADS=5

##################################################
# Assumes that data (fastq) is in data/minion/

##
MSI=msi_docker
MSI_RENAME=./scripts/msi_rename_columns.sh

REF_DB=$PWD/db

#
#chcon -Rt svirt_sandbox_file_t $PWD


###################################################
# No editing required below this line
set -e -u -o pipefail

##
## 
OUT_FOLDER=results
TIMEMEM_LOG=$OUT_FOLDER/time_mem.log
mkdir -p $OUT_FOLDER/

CONF_FILE=msi.conf

set +x

export PATH=$PWD/scripts:$PATH


# First run without blast
msi_time_it "Run7V3_16sBiv" $TIMEMEM_LOG $MSI -c $CONF_FILE -S

# now run blast and binning
msi_time_it "Run7V3_16sBiv:blast" $TIMEMEM_LOG $MSI -c $CONF_FILE
# and fastqc
msi_time_it "Run7V3_16sBiv:qc" $TIMEMEM_LOG $MSI -c $CONF_FILE -r

## change the barcode by ss_sample_id in the results.tsv.gz file (column 1)
for f in results.tsv.gz running.stats.tsv.gz binres.tsv.gz bin.tsv.gz; do
    nf=$(basename $f .tsv.gz)
    $MSI_RENAME -i $OUT_FOLDER/$f -I bivalvia_analysis/samplesheet.tsv -N ss_sample_id | gzip -c - > $OUT_FOLDER/$nf.tmp
    mv $OUT_FOLDER/$nf.tmp $OUT_FOLDER/${nf}_ss_sample_id.tsv.gz
done
echo "All done (files in results/)"
exit
