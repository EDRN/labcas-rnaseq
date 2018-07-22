# Docker image for sample rna-seq data processing

FROM acce/oodt-wmgr:3.0 as oodt-wmgr

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y default-jre
ENV JAVA_HOME=/usr/lib/jvm/default-java

RUN apt-get install -y wget unzip tar bzip2 make gcc libz-dev g++

# install bowtie2
RUN cd /usr/local && \
    wget 'https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.9/bowtie2-2.2.9-linux-x86_64.zip' && \
    unzip bowtie2-2.2.9-linux-x86_64.zip && \
    ln -s ./bowtie2-2.2.9 ./bowtie2 && \
    rm bowtie2-2.2.9-linux-x86_64.zip
ENV PATH=$PATH:/usr/local/bowtie2
ENV BT2_HOME=/usr/local/labcas/backend/pges/rnaseq/bowtie2

# install tophat
RUN cd /usr/local && \
    wget 'https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz' && \
    tar xvfz tophat-2.1.1.Linux_x86_64.tar.gz && \
    ln -s ./tophat-2.1.1.Linux_x86_64 ./tophat && \
    rm tophat-2.1.1.Linux_x86_64.tar.gz
ENV PATH=$PATH:/usr/local/tophat

# install samtools
RUN apt-get install -y libncurses5-dev libncursesw5-dev
RUN cd /usr/local && \
    mkdir samtools_install && \
    wget 'https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2' && \
    tar xvf samtools-1.3.1.tar.bz2 && \
    cd samtools-1.3.1 && \
    make && \
    make prefix=/usr/local/samtools_install install && \
    rm /usr/local/samtools-1.3.1.tar.bz2
ENV PATH=$PATH:/usr/local/samtools_install/bin
    
# install HTSeq
# requires numpmy and matplotlib as pre-requisites
RUN cd /usr/local && \
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /usr/local/miniconda 
ENV PATH=/usr/local/miniconda/bin:$PATH
RUN pip install --upgrade pip
RUN pip install numpy matplotlib

RUN cd /usr/local && \
    wget 'https://pypi.python.org/packages/72/0f/566afae6c149762af301a19686cd5fd1876deb2b48d09546dbd5caebbb78/HTSeq-0.6.1.tar.gz#md5=b7f4f38a9f4278b9b7f948d1efbc1f05' && \
    tar xvfz HTSeq-0.6.1.tar.gz && \
    cd  HTSeq-0.6.1 && \
    python setup.py build && \
    python setup.py install
