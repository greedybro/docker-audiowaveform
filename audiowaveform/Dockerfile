FROM alpine:3.12.0 AS build

ARG AUDIOWAVEFORM_VERSION

# Dependencies
RUN apk update \
    && apk add \
        # Build
        git \
        curl \
        make cmake \
        gcc g++ \
        libsndfile-dev gd-dev libmad-dev libid3tag-dev boost-dev \
        # Static
        libpng-dev \
        zlib-static libpng-static boost-static \
        # Flac
        autoconf automake \
        libtool \
        gettext

# Build flac
RUN curl --location https://github.com/xiph/flac/archive/1.3.3.tar.gz --output flac-1.3.3.tar.gz \
    && tar xzf flac-1.3.3.tar.gz \
    && cd flac-1.3.3 \
    && ./autogen.sh \
    && ./configure --enable-shared=no \
    && make \
    && make install

# Build
RUN git clone https://github.com/bbc/audiowaveform.git \
    && cd audiowaveform \
    && git checkout ${AUDIOWAVEFORM_VERSION} \
    # Install Google Test framework
    && curl --location https://github.com/google/googletest/archive/release-1.10.0.tar.gz --output googletest.tar.gz \
    && tar -xzf googletest.tar.gz \
    && ln -s googletest-release-1.10.0/googletest googletest \
    && ln -s googletest-release-1.10.0/googlemock googlemock \
    # Build
    && mkdir build \
    && cd build \
    && cmake -D BUILD_STATIC=1 .. \
    && make \
    && make install

FROM alpine:3.12.0

RUN apk add --no-cache \
        libgcc libstdc++

COPY --from=build /usr/local/bin/audiowaveform /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/audiowaveform"]
