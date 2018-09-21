#!/bin/bash
#set -x

usage () {
	echo "Usage: sudo makeBootableInstaller.sh /path/to/installinstallmacos.py_output.dmg"
}

if [[ $(id -u) -ne 0 ]]; then
	echo "Must be run as root."
	usage
	exit 1
fi

if [[ $# -ne 1 ]]; then
	echo "The script needs a path to a dmg with the install application."
	usage
	exit 2
fi

installSource="$1"

osVersion=$(basename "$installSource" | awk -F"_|-" '{print $3}')
osMajor=$(echo $osVersion | cut -d"." -f 2) 
osBuild=$(basename "$installSource" | awk -F"_|-" '{print substr($4,1,length($4)-4)}')
case "$osMajor" in
	12)
	osName="Sierra";;
	13)
	osName="High Sierra";;
	14)
	osName="Mojave";;
	*)
	osName="";;
esac

echo "Creating installer dmg for macOS $osVersion $osBuild."

outputDisplay="Install macOS $osName $osVersion $osBuild"
outputFilename=$(echo "$outputDisplay" | sed 's, ,_,g' )
tempDirectory=$(mktemp -d)

attachedOutput=$(hdiutil create -size 10g -fs HFS+ -type SPARSE -volname "$outputDisplay" -plist -attach ${tempDirectory}/${outputFilename} | awk -F"<|>" '/mount-point/ {getline; print $3}')
echo "Mounting target sparseimage."

attachedSource=$(hdiutil attach -plist "$installSource"| awk -F"<|>" '/mount-point/ {getline; print $3}')
echo "Mounting source dmg."

echo "Creating macOS install media."
"${attachedSource}/Install macOS $osName.app/Contents/Resources/createinstallmedia" --volume "$attachedOutput" --nointeraction

hdiutil eject -quiet "$attachedSource"
hdiutil eject -quiet "/Volumes/Install macOS $osName 1"

echo "Converting sparseimage to dmg."
hdiutil convert -format UDZO -quiet -o ${tempDirectory}/${outputFilename}.dmg ${tempDirectory}/${outputFilename}.sparseimage

echo "Scanning dmg for restore"
asr imagescan --source ${tempDirectory}/${outputFilename}.dmg > /dev/null

mv ${tempDirectory}/${outputFilename}.dmg ~/
rm ${tempDirectory}/${outputFilename}.sparseimage
rmdir ${tempDirectory}
echo "Copied installer dmg to ~ and cleaned up."