#!/bin/sh

NAME=HackersParadise
OUTPUT_DIR=build/output
EXPORT_DIR=build/export
ZIP_DIR=build/zip
ZIP_NAME=${NAME}-$(date +%d-%b-%Y).zip

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

echo "Removing .love file..."
rm ${EXPORT_DIR}/${NAME}.love

echo "Copying README..."
cp include/README.txt ${EXPORT_DIR}

echo "Zipping folder..."
zip -9 -r ${ZIP_DIR}/${ZIP_NAME} ${EXPORT_DIR}/ 1>/dev/null

echo "Done."
echo
echo "The build can be found at: ${EXPORT_DIR}/${NAME}.exe"
echo "The zip can be found at: ${ZIP_DIR}/${ZIP_NAME}"
