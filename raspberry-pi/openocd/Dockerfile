FROM balenalib/raspberry-pi-debian:stretch

ARG PKG_NAME=openocd
ARG EMPKG_ROOT=/_empkg
ARG PKG_DIR=$EMPKG_ROOT/$PKG_NAME
ARG SRC_DIR=$PKG_DIR/src
ARG BUILD_DIR=$PKG_DIR/build

# TARBALL / GIT_PUBLIC / GIT_PRIVATE
ARG SRC_TYPE=GIT_PUBLIC

# for SRC_TYPE=TARBALL
#ARG TAR_URL=https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
#ARG TAR_FILE=cmake-3.13.4.tar.gz

# for SRC_TYPE=GIT_PUBLIC
ARG GIT_URL=https://github.com/ntfreak/openocd.git
ARG GIT_BRANCH=master
#ARG GIT_COMMIT=30c3effa89ceda247cd2ff29b5d3f4da8c7a8ff6

#RUN [ "cross-build-start" ]

RUN set -e && \
apt-get -qq update && \
if [ "$SRC_TYPE" = "TARBALL" ]; then \
    apt-get -qq install -y --no-install-recommends cmake build-essential wget && \
    wget -q $TAR_URL && \
    mkdir -p $SRC_DIR && \
    tar zxf $TAR_FILE -C $SRC_DIR --strip-components 1 && \
    rm -rf $TAR_FILE; \
elif [ "$SRC_TYPE" = "GIT_PUBLIC" ]; then \
    apt-get -qq install -y --no-install-recommends build-essential libtool pkg-config autoconf automake texinfo wget git && \
    git clone --single-branch --branch $GIT_BRANCH --depth 1 $GIT_URL $SRC_DIR && \
    if [ -z $GIT_COMMIT ]; then \
        cd $SRC_DIR && \
        git checkout $GIT_COMMIT; \
    fi; \
else \
    echo "[TODO] implement SRC_TYPE=TARBALL or GIT_PRIVATE" && \
    exit 1; \
fi && \
mkdir -p $BUILD_DIR && \
cd $SRC_DIR && \
./bootstrap && \
./configure --enable-sysfsgpio --enable-bcm2835gpio && \
make install && \
mkdir -p $PKG_DIR && \
strip /usr/local/bin/openocd -o $PKG_DIR/openocd && \
cp -r /usr/local/share/openocd/scripts $PKG_DIR/ && \
rm -rf $SRC_DIR $BUILD_DIR && \
apt-get remove -y build-essential libtool pkg-config autoconf automake texinfo wget git && \
apt-get autoremove --purge && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

#RUN [ "cross-build-end" ]
