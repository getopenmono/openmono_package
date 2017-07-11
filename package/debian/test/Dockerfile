FROM debian
MAINTAINER Kristoffer Andersen <ka@openmono.com>
RUN apt-get update -qq && \
  apt-get install -qq wget git sudo curl
ENV SCRIPT_IS_FILE false
ENV INSTALL_SCRIPT ""
CMD if [ $INSTALL_SCRIPT =  "" ] && [ $SCRIPT_IS_FILE != "true" ]; then echo "Please set the install script path env. var: INSTALL_SCRIPT"; exit 1; \
    elif [ $SCRIPT_IS_FILE != "true" ]; then echo "Using script: $INSTALL_SCRIPT" && curl -sL $INSTALL_SCRIPT | bash - && \
    monomake project test && cd test && make; \
    elif [ $SCRIPT_IS_FILE = "true" ] && [ -f $INSTALL_SCRIPT ]; then echo "installing direct from file!" && apt-get update && \
 ( dpkg -i $INSTALL_SCRIPT || echo "Installing deps..." ) && apt-get -f -y install && monomake project test && cd test && make; \
 else echo "INSTALL_SCRIPT is neither file or URL"; fi
