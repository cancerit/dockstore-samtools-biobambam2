FROM  quay.io/wtsicgp/dockstore-biobambam2:2.0.0 as builder

USER  root

RUN bash -c 'apt-get update -yq >& this.log || (cat this.log 1>&2 && exit 1)'
RUN bash -c 'apt-get install -qy --no-install-recommends lsb-release >& this.log || (cat this.log 1>&2 && exit 1)'

RUN mkdir -p $OPT/bin

ADD build/opt-build.sh build/
RUN bash build/opt-build.sh $OPT

FROM  ubuntu:16.04


LABEL maintainer="cgphelp@sanger.ac.uk" \
      uk.ac.sanger.cgp="Cancer, Ageing and Somatic Mutation, Wellcome Sanger Institute" \
      version="1.0.0" \
      description="Samtools and biobambam2 for CASM"
      

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$OPT/biobambam2/bin:$PATH

RUN mkdir -p $OPT
COPY --from=builder $OPT $OPT

## USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

USER    ubuntu
WORKDIR /home/ubuntu

CMD ["/bin/bash"]
