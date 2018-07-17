# image: ccdl/training_rnaseq

FROM rocker/tidyverse:3.4.3
MAINTAINER ccdl@alexslemonade.org

# Get Ensembl / modified for debian.

RUN apt update && apt install -y dirmngr curl bash
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

RUN apt update
RUN export DEBIAN_FRONTEND=noninteractive
RUN `echo 'mariadb-server-10.0 mysql-server/root_password password PASS' | sudo debconf-set-selections`
RUN `echo 'mariadb-server-10.0 mysql-server/root_password_again password PASS' | sudo debconf-set-selections`
RUN sudo apt-get install -y mariadb-server
# RUN printf 'test\n' | apt install -y mariadb-server

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/RMySQL_0.10.15.tar.gz', type = 'source', repos = NULL)"
RUN R -e "BiocInstaller::biocLite('ensembldb')"
RUN R -e "BiocInstaller::biocLite('tximport')"
RUN R -e "BiocInstaller::biocLite('DESeq2')"
RUN R -e "BiocInstaller::biocLite('qvalue')"
RUN R -e "devtools::install_github('wgmao/PLIER', ref = 'a2d4a2aa343f9ed4b9b945c04326bebd31533d4d', dependencies = TRUE)"
RUN R -e "devtools::install_url('https://cran.r-project.org/src/contrib/rjson_0.2.20.tar.gz')"
RUN R -e "BiocInstaller::biocLite('org.Hs.eg.db')"
RUN R -e "BiocInstaller::biocLite('org.Dr.eg.db')"
RUN R -e "BiocInstaller::biocLite('ComplexHeatmap')"
RUN R -e "devtools::install_url('https://cran.r-project.org/src/contrib/ggpubr_0.1.7.tar.gz')"
RUN R -e "devtools::install_github('const-ae/ggsignif', ref = 'aadd9d44a360fc35fc3aef4b0fcdfdb7e1768d27')"
RUN R -e "BiocInstaller::biocLite('ConsensusClusterPlus')"

# FastQC
RUN apt update && apt install -y fastqc


# From Salmon Dockerfile (https://github.com/COMBINE-lab/salmon/blob/master/docker/Dockerfile)
ENV PACKAGES git gcc make g++ cmake libboost-all-dev liblzma-dev libbz2-dev \
    ca-certificates zlib1g-dev curl unzip autoconf
ENV SALMON_VERSION 0.9.1

# salmon binary will be installed in /home/salmon/bin/salmon

### don't modify things below here for version updates etc.

WORKDIR /home

RUN apt update && \
    apt install -y --no-install-recommends ${PACKAGES} && \
    apt clean

RUN curl -k -L https://github.com/COMBINE-lab/salmon/archive/v${SALMON_VERSION}.tar.gz -o salmon-v${SALMON_VERSION}.tar.gz && \
    tar xzf salmon-v${SALMON_VERSION}.tar.gz && \
    cd salmon-${SALMON_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && make && make install

ENV PATH /home/salmon-${SALMON_VERSION}/bin:${PATH}

RUN salmon --version
