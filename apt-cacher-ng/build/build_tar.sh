#!/usr/bin/env bash

# exit on error
set -e

echo "#### Starting building ${CI_COMMIT_REF_SLUG} ####"

PROJECT="salt-apt-cacher-ng-formula"
DATE=`TZ=Europe/Paris date +%Y%m%d%H%M%S`
SUBSHA=$(echo ${CI_COMMIT_SHA} | cut -c -8)

if [[ -z ${CI_COMMIT_TAG} ]]
then
  VERSION="${CI_COMMIT_REF_SLUG}-${DATE}-${SUBSHA}"
else
  VERSION=${CI_COMMIT_TAG}
fi

echo "version: ${VERSION}"

mkdir ${PROJECT}
echo ${VERSION} > ${PROJECT}/version

mv apt-cacher-ng ${PROJECT}/
mv pillar.example ${PROJECT}/

find ${PROJECT} -name ".git" -exec rm -rf {} \;
find ${PROJECT} -name ".gitignore" -exec rm -f {} \;

chmod -R 755 ${PROJECT}

tar -czf "${PROJECT}_${VERSION}.tar.gz" ${PROJECT}
md5sum "${PROJECT}_${VERSION}.tar.gz" | tee "${PROJECT}_${VERSION}.tar.gz.md5"
pwd
echo "The end."
