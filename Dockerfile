FROM ubuntu:latest

LABEL author="Tang Ziya"
# Add openMVG binaries to path
ENV PATH $PATH:/opt/openMVG_Build/install/bin

# Get dependencies
RUN apt-get update && apt-get install -y \
cmake \
build-essential \
graphviz \
git \
coinor-libclp-dev \
libceres-dev \
libflann-dev \
liblemon-dev \
libjpeg-dev \
libpng-dev \
libtiff-dev \
python-minimal \
libglu1-mesa-dev \
libboost-iostreams-dev \
libboost-program-options-dev \
libboost-system-dev \
libboost-serialization-dev \
libgdal-dev \
libeigen3-dev \
libopencv-dev \
libcgal-dev \
libcgal-qt5-dev \
freeglut3-dev \
libglew-dev \
libglfw3-dev \
libgtest-dev && \
apt-get autoclean && apt-get clean

# Clone the openvMVG repo
RUN git clone https://github.com/openMVG/openMVG /opt/openMVG &&\
    cd /opt/openMVG &&\
    git submodule update --init --recursive

# Build
RUN mkdir /opt/openMVG_Build; \
  cd /opt/openMVG_Build; \
  cmake -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX="/opt/openMVG_Build/install" \
    -DOpenMVG_BUILD_TESTS=ON \
    -DOpenMVG_BUILD_EXAMPLES=OFF \
    -DFLANN_INCLUDE_DIR_HINTS=/usr/include/flann \
    -DLEMON_INCLUDE_DIR_HINTS=/usr/include/lemon \
    -DCOINUTILS_INCLUDE_DIR_HINTS=/usr/include \
    -DCLP_INCLUDE_DIR_HINTS=/usr/include \
    -DOSI_INCLUDE_DIR_HINTS=/usr/include \
    ../openMVG/src; \
    make -j 4;

RUN cd /opt/openMVG_Build && make test && make install;
RUN git clone https://github.com/cdcseacave/openMVS /opt/openMVS && \
git clone https://github.com/cdcseacave/VCG /opt/vcglib && \
mkdir /opt/openMVS_build && \
cd /opt/openMVS_build && \
cmake . ../openMVS -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DVCG_ROOT="/opt/vcglib" && \
make -j 4 && make install;
RUN git clone https://github.com/RemoteSensingFrank/UAVProduct /opt/uavproduct && \
mkdir /opt/uavproduct_build && \
cd /opt/uavproduct_build && \
cmake -DCMAKE_BUILD_TYPE=RELEASE ../uavproduct && \
make -j2