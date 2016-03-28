#!/bin/bash

rm -r -f Packages
rm -r -f .build
#rm -r -f .build/debug/Backen*
swift build -Xcc -fblocks

