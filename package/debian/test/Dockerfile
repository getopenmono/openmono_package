FROM debian
RUN apt-get update -qq && \
  apt-get install -qq wget git sudo curl
CMD if [ ! $INSTALL_SCRIPT ]; then echo "Please set ENV var: INSTALL_SCRIPT to a valid URL"; exit 1; fi
CMD echo "Using script: $INSTALL_SCRIPT" && curl -sL $INSTALL_SCRIPT | bash - && \
  monomake project test && cd test && make