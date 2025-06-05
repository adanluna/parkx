#!/bin/bash

# 1. Leer versión de pubspec.yaml
VERSION_LINE=$(grep '^version: ' pubspec.yaml)
IFS='+' read -r VERSION BUILD <<< "${VERSION_LINE#version: }"

# 2. Ruta del archivo Info.plist
PLIST="ios/Runner/Info.plist"

# 3. Actualizar valores en Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$PLIST"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD" "$PLIST"

echo "✅ Info.plist actualizado:"
echo "   Version: $VERSION"
echo "   Build:   $BUILD"

