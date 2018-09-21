# makeBootableInstaller
Create a dmg for bootable macOS installers from installinstallmacos.py output

This script takes a .dmg from [installinstallmacos.py](https://github.com/munki/macadmin-scripts/blob/master/installinstallmacos.py) as input and outputs a dmg of createinstallmedia output suitable for restoring to a USB drive.

Usage: sudo makeBootableInstaller.sh /path/to/installinstallmacos.py_output.dmg


I'm not happy with line 52 
```
hdiutil eject -quiet "/Volumes/Install macOS $osName 1"
```
but createinstallmedia changes the name of the volume (and doesn't output the name), and it should always match what the installer volume is called.
