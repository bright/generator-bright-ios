#!/bin/sh

set -e
set -u
set -o pipefail

security delete-keychain ios-build-<%= projectName %>.keychain
echo "Orignal keychains as seen in remove-key.sh: $ORIGINAL_KEYCHAINS"
security list-keychains -d user -s $ORIGINAL_KEYCHAINS
