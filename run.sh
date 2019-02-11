#!/bin/sh

[ "${1}" = "keep" ] || ./build.sh
love/love.exe build/output/
