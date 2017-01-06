FROM debian
RUN apt-get update -qq && \
  apt-get install -qq wget git sudo curl
ENV INSTALL_SCRIPT https://github.com/getopenmono/openmono_package/releases/download/SDKv1_5/install.sh
CMD echo "Using script: $INSTALL_SCRIPT" && curl -sL $INSTALL_SCRIPT | bash - && \
  monomake project test && cd test && make