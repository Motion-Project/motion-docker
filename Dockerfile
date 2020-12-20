FROM ubuntu:18.04 AS build

# Setup build environment
RUN export DEBIAN_FRONTEND=noninteractive; \
    export DEBCONF_NONINTERACTIVE_SEEN=true; \
    apt-get update -qqy && apt-get install -qqy --option Dpkg::Options::="--force-confnew" --no-install-recommends \
    autoconf automake build-essential pkgconf libtool libzip-dev libjpeg-dev tzdata \
    git libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libavdevice-dev \
    libwebp-dev gettext autopoint libmicrohttpd-dev ca-certificates imagemagick curl wget \
    libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libavdevice-dev ffmpeg x264 && \
    apt-get --quiet autoremove --yes && \
    apt-get --quiet --yes clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Motion-Project/motion.git  && \
   cd motion  && \
   autoreconf -fiv && \
   ./configure && \
   make clean && \
   make && \
   make install && \
   cd .. && \
   rm -fr motion

FROM ubuntu:18.04
LABEL maintainer="TBD"

# Setup Timezone packages and avoid all interaction. This will be overwritten by the user when selecting TZ in the run command
RUN export DEBIAN_FRONTEND=noninteractive; \
    export DEBCONF_NONINTERACTIVE_SEEN=true; \
    apt-get update -qqy && apt-get install -qqy --option Dpkg::Options::="--force-confnew" --no-install-recommends \
    tzdata libmicrohttpd12 ca-certificates imagemagick curl wget ffmpeg x264 && \
    apt-get --quiet autoremove --yes && \
    apt-get --quiet --yes clean && \
    rm -rf /var/lib/apt/lists/*

# Setup parameters
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="Dockerfile" \
    org.label-schema.license="GPLv3" \
    org.label-schema.name="motion" \
    org.label-schema.url="https://motion-project.github.io/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/Motion-Project/motion.git"

# Copy build binary
COPY --from=build /usr/local /usr/local

# R/W needed for motion to update configurations
VOLUME /usr/local/etc/motion
# R/W needed for motion to update Video & images
VOLUME /var/lib/motion

CMD test -e /usr/local/etc/motion/motion.conf || \
    cp /usr/local/etc/motion/motion-dist.conf /usr/local/etc/motion/motion.conf

CMD [ "motion", "-n" ]
