FROM r-base:4.0.5
MAINTAINER jselvi@pentester.es

RUN apt update; apt -y install python3 python3-pip #libcurl4-openssl-dev libssl-dev libxml2-dev
RUN python3 -m pip install ngram statistics

RUN mkdir /dga

COPY R/install.R /dga/
RUN Rscript /dga/install.R

COPY data/alexa-32k.txt /dga/
COPY data/dga-32k.txt /dga/
COPY init.sh /dga/
COPY data/features_extraction_with_masking.py /dga/
COPY data/top15_features.py /dga/
COPY R/run.R /dga/

CMD ["bash", "/dga/init.sh"]
