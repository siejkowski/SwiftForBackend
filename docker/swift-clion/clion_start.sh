#!/bin/bash

mkdir -p /root/.CLion2016.1/config/plugins
mkdir -p /root/.CLion2016.1/config/options
cp /clion-swift-145.256.37.jar /root/.CLion2016.1/config/plugins/
echo '<application>\n  <component name="EditorColorsManagerImpl">\n    <global_color_scheme name="Darcula" />\n  </component>\n</application>' >> /root/.CLion2016.1/config/options/colors.scheme.xml
echo '<application>\n  <component name="EditorSettings">\n    <option name="ARE_LINE_NUMBERS_SHOWN" value="true" />\n  </component>\n</application>' >> /root/.CLion2016.1/config/options/editor.xml
echo '<application>\n  <component name="LafManager">\n    <laf class-name="com.intellij.ide.ui.laf.darcula.DarculaLaf" />\n  </component>\n</application>' >> /root/.CLion2016.1/config/options/laf.xml
cd clion-145.256.37/bin 
./clion.sh

