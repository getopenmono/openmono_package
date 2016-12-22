FROM debian
RUN apt-get update -qq && \
  apt-get install -qq qt5-default qttools5-dev-tools devscripts libusb-1.0-0-dev \
   libudev-dev libqt5serialport5-dev libc6-i386 wget git sudo icnsutils graphicsmagick
RUN apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs
RUN export GCC_DIR="$HOME/gcc-arm-none-eabi-5_2-2015q4" && \
  export GCC_ARCHIVE="$HOME/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2" && \
  export GCC_URL="https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2" && \
  wget $GCC_URL -O $GCC_ARCHIVE; tar xfvj $GCC_ARCHIVE -C $HOME
ENV BRANCH release15
ENV COPY_DEST /Desktop/.
CMD export PATH=$PATH:$HOME/gcc-arm-none-eabi-5_2-2015q4/bin && \
  echo "Using branch: $BRANCH and copy to destination volume: $COPY_DEST" && \
  git clone -b $BRANCH https://github.com/getopenmono/openmono_package.git && \
  cd openmono_package/package/debian && \
  pwd && \
  bash build.sh -ci && \
  cp -r debpackage/*.deb $COPY_DEST