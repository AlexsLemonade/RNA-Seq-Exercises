FROM rocker/tidyverse:3.5.1
MAINTAINER ccdl@alexslemonade.org
WORKDIR /rocker-build/

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install dialog apt-utils -y

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    build-essential \
    libxml2-dev \
    libsqlite-dev \
    libmariadbd-dev \
    libmariadbclient-dev \
    libmariadb-client-lgpl-dev \
    libpq-dev \
    libssh2-1-dev \
    pandoc \
    libmagick++-dev \
    time

# scater and scran need updated rlang
RUN R -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/rlang/rlang_0.3.1.tar.gz')"

RUN apt update && apt install -y dirmngr curl bash
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    && install2.r --error \
    --deps TRUE \
    rjson \
    ggpubr \
    Rtsne

RUN R -e "BiocManager::install(c('ensembldb', 'DESeq2', 'qvalue', 'org.Hs.eg.db', 'org.Dr.eg.db', 'org.Mm.eg.db', 'org.Cf.eg.db', 'ComplexHeatmap', 'ConsensusClusterPlus', 'scran', 'scater'), update = FALSE)" 

# Install R packages from github and urls
# Need most updated version of tximport so AlevinQC will install later
RUN R -e "devtools::install_github('mikelove/tximport', ref = 'b5b5fe11b0093b4b2784f982277b2aa66d2607f7')"
RUN R -e "devtools::install_github('wgmao/PLIER', ref = 'a2d4a2aa343f9ed4b9b945c04326bebd31533d4d', dependencies = TRUE)"
RUN R -e "devtools::install_github('const-ae/ggsignif', ref = 'aadd9d44a360fc35fc3aef4b0fcdfdb7e1768d27')"
RUN R -e "devtools::install_github('csoneson/alevinQC', ref = '6ca73b1744cbd969036f80b7c7dddbe7d1cf99ee', dependencies = TRUE)"

# colorblind friendly palettes
RUN R -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/colorspace/colorspace_1.4-0.tar.gz')"
RUN R -e "devtools::install_github('clauswilke/colorblindr', ref = '1ac3d4d62dad047b68bb66c06cee927a4517d678', dependencies = TRUE)"

# FastQC
RUN apt update && apt install -y fastqc

ENV PACKAGES git gcc make g++ libboost-all-dev liblzma-dev libbz2-dev \
    ca-certificates zlib1g-dev curl unzip autoconf

ENV SALMON_VERSION 0.13.1

# salmon binary will be installed in /home/salmon/bin/salmon
# don't modify things below here for version updates etc.

WORKDIR /home

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

# Apt doesn't have the latest version of cmake, so install it using their script.
RUN apt remove cmake cmake-data -y

RUN wget --quiet https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3-Linux-x86_64.sh && \
    mkdir /opt/cmake && \
    sh cmake-3.13.3-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
    sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

RUN curl -k -L https://github.com/COMBINE-lab/salmon/archive/v${SALMON_VERSION}.tar.gz -o salmon-v${SALMON_VERSION}.tar.gz && \
    tar xzf salmon-v${SALMON_VERSION}.tar.gz && \
    cd salmon-${SALMON_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && make && make install

# fastp 
RUN git clone https://github.com/OpenGene/fastp.git
RUN cd fastp && \
    make && \
    sudo make install

WORKDIR /home

# bedtools
RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.28.0/bedtools-2.28.0.tar.gz
RUN tar -zxvf bedtools-2.28.0.tar.gz
RUN cd bedtools2 && \
    make && \
    mv bin/* /usr/local/bin

# MashMap
RUN wget https://github.com/marbl/MashMap/releases/download/v2.0/mashmap-Linux64-v2.0.tar.gz
RUN tar -zxvf mashmap-Linux64-v2.0.tar.gz
RUN cd mashmap-Linux64-v2.0 && \
    mv mashmap /usr/local/bin

# MultiQC
RUN apt update && apt install -y python-pip
RUN pip install multiqc

