#!/bin/sh

echo "Clean output directory..."
[ ! -d build/output ] && mkdir -p build/output
rm -r build/output/* 2>/dev/null

echo "Copying files..."
cp -r assets/ build/output/
cp src/* build/output/

echo "Done."
