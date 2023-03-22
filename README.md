[![Docker Image CI](https://github.com/mattgalbraith/tophat2-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/tophat2-docker-singularity/actions/workflows/docker-image.yml)

# tophat2-docker-singularity

## Build Docker container for TopHat2 and (optionally) convert to Apptainer/Singularity.  

TopHat is a fast splice junction mapper for RNA-Seq reads. It aligns RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons.  
https://ccb.jhu.edu/software/tophat/index.shtml    
  
#### Requirements:
Bowtie2  
Install within image using micromamba + env.yaml file  
https://github.com/mamba-org/micromamba-docker  
  
## Build docker container:  

### 1. For TopHat2 installation instructions:  
https://ccb.jhu.edu/software/tophat/tutorial.shtml  


### 2. Build the Docker Image

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level tophat2-docker-singularity directory
docker build -t tophat2:2.1.1 . # tag should match software version
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
``` bash
docker run --rm -it tophat2:2.1.1 tophat2 --help 

# Optional: Run with test data
wget https://ccb.jhu.edu/software/tophat/downloads/test_data.tar.gz
tar -xzvf test_data.tar.gz
cd test_data
docker run --rm -it -v "$PWD":/data -w /data tophat2:2.1.1 tophat -r 20 test_ref reads_1.fq reads_2.fq
# -v mounts current working dir as /data in container
# -w sets working dir in conatiner
# SUCCESSFUL TEST RESULT = output lines similar to this: 

# [2023-03-22 00:29:02] Beginning TopHat run (v2.1.1)
# -----------------------------------------------
# [2023-03-22 00:29:02] Checking for Bowtie
# 		  Bowtie version:	 2.2.5.0
# [2023-03-22 00:29:03] Checking for Bowtie index files (genome)..
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o tophat2.1.1-docker.tar && gzip tophat2.1.1-docker.tar # = IMAGE_ID of tophat image
docker run -v "$PWD":/data --rm -it singularity:1.1.5 bash -c "singularity build /data/tophat2.1.1.sif docker-archive:///data/tophat2.1.1-docker.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the tophat2.1.1.sif file to the system on which you want to run TopHat2 from the Singularity container  

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available  
``` bash
# set up path to the Singularity container
TOPHAT2_SIF=path/to/tophat2.1.1.sif

# Test that tophat2 can run from Singularity container
singularity run $TOPHAT2_SIF tophat2 --help # depending on system/version, singularity may be called apptainer
```