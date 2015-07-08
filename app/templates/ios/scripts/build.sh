#!/bin/sh


# expects variable PROVISIONING_PROFILE_FILE to point to profile path

set -e
set -o pipefail

function cleanup {
    echo "Removing key"
    . ./remove-key.sh
    echo "Removing build directory"
    rm -rf $BUILD_DIR
}

trap cleanup EXIT

echo "Ensure DerivedData is waxed out"
rm -rf $HOME/Library/Developer/Xcode/DerivedData/

. ./add-key.sh

APP_NAME="<%= projectName %>"
CODE_SIGN_IDENTITY="iPhone Distribution: Bright Inventions SC (CBE57AW4A4)"
OUT_DIR="$PWD/../out"
BUILD_DIR="$OUT_DIR/build"
BUILD_RESULTS_DIR="$BUILD_DIR/Release-iphoneos"

echo "Recreate out directory"
rm -rf $OUT_DIR
mkdir $OUT_DIR
mkdir $BUILD_DIR

echo "Installing Provisioning Profile"
./installProvisioningProfile.sh  $PROVISIONING_PROFILE_FILE

PROVISIONING_PROFILE_UUID=`./mpParse -f $PROVISIONING_PROFILE_FILE -o uuid`

/usr/local/bin/xctool                                                   \
    -workspace ../<%= projectName %>.xcworkspace                           \
    -scheme $APP_NAME                                             \
    -sdk iphoneos                                                       \
    -configuration Release                                              \
    OBJROOT=$BUILD_DIR                                                  \
    SYMROOT=$BUILD_DIR                                                  \
    ONLY_ACTIVE_ARCH=NO                                                 \
    CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY"                            \
    PROVISIONING_PROFILE="$PROVISIONING_PROFILE_UUID"                   \
    OTHER_CODE_SIGN_FLAGS="--keychain ios-build-<%= projectName %>.keychain"


xcrun -log -sdk iphoneos PackageApplication "$BUILD_RESULTS_DIR/$APP_NAME.app" -o "$OUT_DIR/$APP_NAME.ipa"

(cd $BUILD_RESULTS_DIR/; zip -r $OUT_DIR/$APP_NAME.app.dsym.zip $APP_NAME.app.dSYM)
