#!/bin/bash

# this should be run from inside a debian Docker test ebvironment,
# with the OpenMono SDK installed

git clone https://github.com/getopenmono/openmono_package.git && \
cd openmono_package/tests && \
bash new_project.sh && \
bash app_suite.sh &&
echo "Test suite success!" || exit 1
