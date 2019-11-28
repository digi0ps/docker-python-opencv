FROM python:3.6

ENV OPENCV_VERSION=3.3.0
RUN CPUCOUNT=$(nproc)
RUN mkdir -p /usr/src/app 
WORKDIR /usr/src/app 

# Various Python and C/build deps
RUN apt-get update && apt-get install -y \ 
    build-essential cmake git pkg-config libgtk-3-dev wget \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev \
    libx264-dev libjpeg-dev libpng-dev libtiff-dev gfortran openexr \
    libatlas-base-dev python3-dev python3-numpy libtbb2 libtbb-dev \
    libdc1394-22-dev && pip install numpy

# Install OpenCV
RUN mkdir -p /opt && cd /opt && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm -rf ${OPENCV_VERSION}.zip && \
    mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
    cd /opt/opencv-${OPENCV_VERSION}/build && \
    cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_FFMPEG=NO \
    -D WITH_IPP=NO \
    -D WITH_OPENEXR=NO \
    -D WITH_TBB=YES \
    -D BUILD_EXAMPLES=NO \
    -D BUILD_ANDROID_EXAMPLES=NO \
    -D INSTALL_PYTHON_EXAMPLES=NO \
    -D BUILD_DOCS=NO \
    -D BUILD_TESTS=NO \
    -D BUILD_PERF_TESTS=NO \
    -D BUILD_JAVA=NO \
    -D BUILD_opencv_python2=NO \
    -D BUILD_opencv_python3=ON \
    -D PYTHON3_EXECUTABLE=/usr/local/bin/python \
    -D PYTHON3_INCLUDE_DIR=/usr/local/include/python3.6m/ \
    -D PYTHON3_LIBRARY=/usr/local/lib/libpython3.so \
    -D PYTHON_LIBRARY=/usr/local/lib/libpython3.so \
    -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.6/site-packages/ \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/site-packages/numpy/core/include/ \
    .. && \
    make VERBOSE=1 && \
    make -j2 && \
    make install && \
    rm -rf /opt/opencv-${OPENCV_VERSION} && \
    ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so /usr/local/lib/python3.6/site-packages/cv2.so