#!/bin/bash

mkdir -p /root/.CLion2016.1/config/plugins
mkdir -p /root/.CLion2016.1/config/options
cp /clion-swift-145.256.37.jar /root/.CLion2016.1/config/plugins/
cp -r /IdeaVim /root/.CLion2016.1/config/plugins/
echo '<application><component name="EditorColorsManagerImpl"><global_color_scheme name="Darcula" /></component></application>' > /root/.CLion2016.1/config/options/colors.scheme.xml
echo '<application><component name="EditorSettings"><option name="ARE_LINE_NUMBERS_SHOWN" value="true" /></component></application>' > /root/.CLion2016.1/config/options/editor.xml
echo '<application><component name="LafManager"><laf class-name="com.intellij.ide.ui.laf.darcula.DarculaLaf" /></component></application>' > /root/.CLion2016.1/config/options/laf.xml
echo '<application><component name="KeymapManager"><active_keymap name="Mac OS X 10.5+" /></component></application>' > /root/.CLion2016.1/config/options/keymap.xml
cd clion-145.256.37/bin 
./clion.sh

