#!/bin/sh

OUTPUT_DIR=build/output
EXPORT_DIR=build/export
NAME=HackersParadise

./build.sh

echo "----"
echo "Creating .love file..."
mkdir -p ${EXPORT_DIR}
cd ${OUTPUT_DIR}
zip -9 -r ../../${EXPORT_DIR}/${NAME}.love * 1>/dev/null
cd ../..

echo "Creating .exe file..."
cat love/love.exe ${EXPORT_DIR}/${NAME}.love > ${EXPORT_DIR}/${NAME}.exe
cp love/* ${EXPORT_DIR}/

echo "Done."
echo
echo "The build can be found at: ${EXPORT_DIR}/${NAME}.exe"
