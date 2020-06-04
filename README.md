# mussels_package


Steps to process the data in a computer with Linux OS and internet access.

## 1. Setup

### 1.a Get the docker image with MSI

    docker pull nunofonseca/msi:latest
    chcon -Rt svirt_sandbox_file_t $PWD


### 1.b Download the FASTQ files from ENA

    cd fastq; ./download.sh ; cd ..


### 1.c Download the BLAST nt database from NCBI

    ./scripts/msi_install.sh -i . -x blast_db

This step will take a considerable amount of time and it will require about 80GB of storage.


## 2. Run the process_data.sh to analyse the data

    ./process_data.sh


The files produced will be placed in the results folder.



