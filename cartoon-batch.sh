#!/bin/sh
GIMP_BIN=/Applications/GIMP.app/Contents/MacOS/GIMP
#$GIMP_BIN -i -f -d --verbose -b "(cartoon_batch \"frame\" \".\")" -b "(gimp-quit 0)"
$GIMP_BIN -i -f -d --verbose -b "(script-fu-CarTOONizeCLI \"frame\")" -b "(gimp-quit 0)"
