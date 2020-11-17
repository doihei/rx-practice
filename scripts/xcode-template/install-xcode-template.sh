#!/usr/bin/env sh

# Configuration
XCODE_TEMPLATE_DIR=$HOME'/Library/Developer/Xcode/Templates/File Templates/YoungJump'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy Unio file templates into the local Unio template directory
xcodeTemplate () {
  echo "==> Copying up Unio Xcode file templates..."

  if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    rm -R "$XCODE_TEMPLATE_DIR"
  fi
  mkdir -p "$XCODE_TEMPLATE_DIR"

  cp -R $SCRIPT_DIR"/Templates/ViewController.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/CustomView.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/CustomCell.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/CustomItemCell.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/Section.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/ViewModel.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/Wireframe.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/Builder.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/UseCase.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/Repository.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/Gateway.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/Request.xctemplate" "$XCODE_TEMPLATE_DIR"
  cp -R $SCRIPT_DIR"/Templates/APIError.xctemplate" "$XCODE_TEMPLATE_DIR"
}

xcodeTemplate

echo "==> ... success!"
