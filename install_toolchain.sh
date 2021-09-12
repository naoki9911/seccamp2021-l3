#!/bin/bash

# thanks to https://www.marketechlabo.com/bash-batch-best-practice/
set -e -o pipefail

function raise() {
  echo $1 1>&2
  return 1
}

err_buf=""
function err() {
  # Usage: trap 'err ${LINENO[0]} ${FUNCNAME[1]}' ERR
  status=$?
  lineno=$1
  func_name=${2:-main}
  err_str="ERROR: [`date +'%Y-%m-%d %H:%M:%S'`] ${SCRIPT}:${func_name}() returned non-zero exit status ${status} at line ${lineno}"
  echo ${err_str}
  err_buf+=${err_str}
}

function finally() {
  echo "end"
}

SCRIPT_DIR=$(cd $(dirname $0);pwd)
cd $SCRIPT_DIR

sudo apt-get update && sudo apt-get install -y \
    build-essential git curl software-properties-common openjdk-11-jre \
    cmake clang clang-9 bison flex libreadline-dev \
    gawk tcl-dev libffi-dev graphviz xdot pkg-config python3 libboost-system-dev \
    libboost-python-dev libboost-filesystem-dev zlib1g-dev yosys
git clone --recursive https://github.com/virtualsecureplatform/Iyokan

cd Iyokan
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..
make -j$(nproc)

