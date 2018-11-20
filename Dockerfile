FROM  quay.io/wtsicgp/dockstore-biobambam2:2.0.0 as builder

USER  root

RUN apk update\
    && apk upgrade \
    && apk add --no-cache \
    bzip2-dev \
    xz-dev \
    curl-dev \
    ncurses-dev \
    perl-json \
    >& this.log || (cat this.log 1>&2 && exit 1)

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$PATH
ENV LD_LIBRARY_PATH $OPT/lib:$LD_LIBRARY_PATH

RUN mkdir -p $OPT/bin

ADD build/opt-build.sh build/
RUN bash build/opt-build.sh $OPT

ADD scripts/splitXamToInterleaved.sh $OPT/bin
RUN chmod a+x $OPT/bin//splitXamToInterleaved.sh

LABEL maintainer="cgphelp@sanger.ac.uk" \
      vendor="Cancer, Ageing and Somatic Mutation, Wellcome Sanger Institute" \
      uk.ac.sanger.cgp.version="1.0.0" \
      uk.ac.sanger.cgp.description="Samtools and biobambam2 for CASM"
      
USER cgp
WORKDIR /home/cgp

CMD ["/bin/bash"]
