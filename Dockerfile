################# BASE IMAGE ######################
FROM --platform=linux/amd64 mambaorg/micromamba:1.3.1-focal
# Micromamba for fast building of small conda-based containers.
# https://github.com/mamba-org/micromamba-docker
# The 'base' conda environment is automatically activated when the image is running.

################## METADATA ######################
LABEL base_image="mambaorg/micromamba:1.3.1-focal"
LABEL version="1.0.0"
LABEL software="Tophat"
LABEL software.version="2.1.1"
LABEL about.summary="TopHat is a fast splice junction mapper for RNA-Seq reads. It aligns RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons."
LABEL about.home="https://ccb.jhu.edu/software/tophat/index.shtml"
LABEL about.documentation="https://ccb.jhu.edu/software/tophat/manual.shtml"
LABEL about.license_file=""
LABEL about.license=""

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>

################## INSTALLATION ######################

# Copy the yaml file to your docker image and pass it to micromamba
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes