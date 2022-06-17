#!/usr/bin/env bash


SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/$1"
PACKAGE_NAME=$(basename "$SCRIPT_DIRECTORY")
PACKAGE_ZIP=${PACKAGE_NAME}.zip
MAIN_FILE=$2

pushd "$SCRIPT_DIRECTORY" > /dev/null || exit

rm -rf .package "${PACKAGE_NAME}"-*.zip > /dev/null
mkdir .package

pip3 install --target .package  $(grep -ivE "pytest" requirements.txt) > /dev/null

cp ${MAIN_FILE} .package/

popd > /dev/null || exit

echo "${SCRIPT_DIRECTORY}"/"${PACKAGE_ZIP}"

