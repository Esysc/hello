#! /bin/sh

set -o errexit
set -o xtrace

echo "\n\n*** Printing Conan information"
conan --version

# Remove all packages in the cache before anything to avoid corrupted or outdated caches
echo "\n\n*** Cleaning conan cache"
conan remove -f "*"

echo "\n\n*** Install dependencies"
conan install \
    --update \
    -s arch=armv8 \
    -s arch_build=armv8 \
    -s arch_target=armv8 \
    repo.git/${CONANFILE_DIR}

VERSION=0.1

cp repo.git/conanfile.py .
conan build build-dir --source-folder repo.git


echo "\n\n*** Package"
echo "Package name :  $PKG_NAME"
echo "\n\nDone"
