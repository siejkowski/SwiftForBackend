#!/bin/bash

mkdir -p /root/.CLion15/config/plugins
mkdir -p /root/.CLion15/config/options
cp /clion-swift-145.184.4.jar /root/.CLion15/config/plugins/
echo '<application><component name="EditorColorsManagerImpl"><global_color_scheme name="Darcula" /></component></application>' >> /root/.CLion15/config/options/colors.scheme.xml
echo '<application><component name="EditorSettings"><option name="ARE_LINE_NUMBERS_SHOWN" value="true" /></component></application>' >> /root/.CLion15/config/options/editor.xml
echo '<application><component name="LafManager"><laf class-name="com.intellij.ide.ui.laf.darcula.DarculaLaf" /></component></application>' >> /root/.CLion15/config/options/laf.xml
cd clion-145.184.4/bin 
./clion.sh

