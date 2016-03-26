#!/bin/bash

rm -r -f .build/debug/KituraSampl*
swift build -Xcc -fblocks

