#!/bin/bash

mkdir -p /root/.CLion2016.1/config/plugins
mkdir -p /root/.CLion2016.1/config/options
cp /clion-swift-*.jar /root/.CLion2016.1/config/plugins/
cp -r /IdeaVim /root/.CLion2016.1/config/plugins/

ln -s /swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10/usr/lib/liblldb.so.3.9.0 /swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10/usr/lib/liblldb.so.3 
echo '<application><component name="CPPToolchains"><option name="detectedVersion" value="4" /></component><component name="SwiftSettings" SDK_DIR="/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10" USE_SWIFT_DEBUGGER="true" /></application>' > /root/.CLion2016.1/config/options/other.xml

echo '<application><component name="EditorColorsManagerImpl"><global_color_scheme name="Darcula" /></component></application>' > /root/.CLion2016.1/config/options/colors.scheme.xml
echo '<application><component name="EditorSettings"><option name="ARE_LINE_NUMBERS_SHOWN" value="true" /></component></application>' > /root/.CLion2016.1/config/options/editor.xml
echo '<application><component name="LafManager"><laf class-name="com.intellij.ide.ui.laf.darcula.DarculaLaf" /></component></application>' > /root/.CLion2016.1/config/options/laf.xml
echo '<application><component name="KeymapManager"><active_keymap name="Mac OS X 10.5+" /></component></application>' > /root/.CLion2016.1/config/options/keymap.xml
cd clion-*/bin 
./clion.sh

