#!/bin/bash

RESOURCE_REPO_PATH="../font-image-service"

echo "Coping Fonts..."
cp -r "${RESOURCE_REPO_PATH}/fonts/" "TextContour/Fonts/"
echo "Coping Fonts... Done."

echo "Coping Images..."
cp -r "${RESOURCE_REPO_PATH}/images/" "TextContour/Images/"
echo "Coping Images... Done."

ruby "scripts/add-resources.rb"
