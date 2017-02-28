#!/bin/bash

RESOURCE_REPO_PATH="../font-image-service"
FONTS_PATH="TextContour/Fonts"
IMAGES_PATH="TextContour/Images"
PLIST_PATH="TextContour/Info.plist"
PLISTBUDDY="/usr/libexec/PlistBuddy"

git checkout TextContour.xcodeproj/project.pbxproj TextContour/Info.plist

# Copy phase
echo "Coping Fonts..."
cp -r "${RESOURCE_REPO_PATH}/fonts/" "$FONTS_PATH"
echo "Coping Fonts... Done."

echo "Coping Images..."
cp -r "${RESOURCE_REPO_PATH}/images/" "$IMAGES_PATH"
echo "Coping Images... Done."

# Add resources phase
ruby "scripts/add-resources.rb"

# Add to Info.plist phase
echo "Add fonts to Info.plist..."
${PLISTBUDDY} -c "Print UIAppFonts" "${PLIST_PATH}" > /dev/null 2>&1
[[ "$?" = 0 ]] && ${PLISTBUDDY} -c "Delete UIAppFonts" "${PLIST_PATH}"
${PLISTBUDDY} -c "Add UIAppFonts array" "${PLIST_PATH}"
index=0
ls ${FONTS_PATH} | while read filename ; do
    command="${PLISTBUDDY} -c \"Add UIAppFonts:${index} string Fonts/${filename}\" \"${PLIST_PATH}\""
    eval $command
    index=$(( index + 1))
done
echo "Add fonts to Info.plist... Done."
