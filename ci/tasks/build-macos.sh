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
    --install-folder build \
    -s arch=armv8 \
    repo.git/${CONANFILE_DIR}

VERSION=0.1

echo "\n\n*** Configure"
cmake -Hrepo.git/${CONANFILE_DIR} -Bbuild -GNinja \
    -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_INSTALL_PREFIX=install \
    -DVERSION_STRING=$VERSION \


echo "\n\n*** Build"
cmake --build build -- -j "$(sysctl -n hw.physicalcpu)"


echo "\n\n*** Package"
echo "Package name :  $PKG_NAME"

CPACK_COMMAND="cpack --config build/CPackConfig.cmake -B "$PWD"/build-dir -D \"CPACK_COMPONENTS_ALL=Development;Runtime\" -D CPACK_PACKAGE_FILE_NAME=$PKG_NAME-$VERSION"
echo "CPACK command : $CPACK_COMMAND"

if [ ! -z "$SINGLE_PACKAGE" ]; then
    echo "No single package"
    CPACK_COMMAND=$CPACK_COMMAND" -D CPACK_INCLUDE_TOPLEVEL_DIRECTORY=OFF -D CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE=ON -D CPACK_GENERATOR=TGZ"
fi

$CPACK_COMMAND

if [ -z "$SINGLE_PACKAGE" ]; then
   echo "Single package"
   echo "Bundling together the artifacts"
   REPO_PATH=$(readlink repo.git)
   cd $(readlink build-dir)
   tar cvf $PKG_NAME-$VERSION.tar *.zip
   echo "Cleanup unused zip files"
   rm -rf *.zip
fi

echo "\n\nDone"
