#!/bin/sh

NAME=HackersParadise
OUTPUT_DIR=build/output
EXPORT_DIR=build/${NAME}
ZIP_DIR=build/zip
ZIP_NAME=${NAME}-$(date +%d-%b-%Y).zip

./build.sh

echo "----"
echo "Creating .love file..."
mkdir -p ${EXPORT_DIR}
cd ${OUTPUT_DIR}
zip -9 -qur ../../${EXPORT_DIR}/${NAME}.love *
cd ../..

echo "Creating .exe file..."
cat love/love.exe ${EXPORT_DIR}/${NAME}.love > ${EXPORT_DIR}/${NAME}.exe
cp love/* ${EXPORT_DIR}/

echo "Removing .love file..."
rm ${EXPORT_DIR}/${NAME}.love

echo "Copying README..."
cp include/README.txt ${EXPORT_DIR}

echo "Zipping folder..."
mkdir -p ${ZIP_DIR}
cd build
zip -9 -qur ../${ZIP_DIR}/${ZIP_NAME} ${NAME}/
cd ..

echo "Done."
echo
echo "The build can be found at: ${EXPORT_DIR}/${NAME}.exe"
echo "The zip can be found at: ${ZIP_DIR}/${ZIP_NAME}"
