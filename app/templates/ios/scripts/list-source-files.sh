#!/usr/bin/env bash
find . -type f \(                \
      -name "*.m"                \
   -o -name "*.h"                \
   -o -name "*.plist"            \
\)
