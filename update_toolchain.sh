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

rm -rf Iyokan-L1

cd Iyokan
git pull origin master
git submodule update --recursive
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ..
make -j$(nproc)
