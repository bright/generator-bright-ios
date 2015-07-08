#!bin/sh

set -e
set -o pipefail

KEYCHAIN_NAME=ios-build-<%= projectName %>.keychain
KEYCHAIN_PASSWORD=12345

KEYCHAIN_PATH=$HOME/Library/Keychains/$KEYCHAIN_NAME

if [ -f $KEYCHAIN_PATH ];
then
	echo "Keychain file already exists, removing it"
	security delete-keychain $KEYCHAIN_NAME
fi

# Create a custom keychain
security create-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN_NAME

# Unlock the keychain
security unlock-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN_NAME

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l $KEYCHAIN_PATH

# Add certificates to keychain and allow codesign to access them
security import ./certs/apple.cer -k $KEYCHAIN_PATH -T /usr/bin/codesign
#security import ./certs/dist.cer -k $KEYCHAIN_PATH -T /usr/bin/codesign
security import ./certs/certs.p12 -k $KEYCHAIN_PATH -P $KEYCHAIN_PASSWORD -T /usr/bin/codesign

# based on http://stackoverflow.com/questions/7399134/other-code-sign-flags-keychain-flag-ignored
ORIGINAL_KEYCHAINS=`security list-keychains -d user`
ORIGINAL_KEYCHAINS=${originalKeychainsHack1}     # remove " characters from ORIGINAL_KEYCHAINS
ORIGINAL_KEYCHAINS=${originalKeychainsHack2} # remove new line characters from ORIGINAL_KEYCHAINS
export ORIGINAL_KEYCHAINS
echo "Original Keychains as seen in add-key.sh: $ORIGINAL_KEYCHAINS"
security list-keychains -d user -s $ORIGINAL_KEYCHAINS $KEYCHAIN_NAME
