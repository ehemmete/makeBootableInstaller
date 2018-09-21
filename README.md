# makeBootableInstaller
Create a dmg for bootable macOS installers from installinstallmacos.py output

This script takes a .dmg from [installinstallmacos.py](https://github.com/munki/macadmin-scripts/blob/master/installinstallmacos.py) as input and outputs a dmg of createinstallmedia output suitable for restoring to a USB drive. The output is moved to your home folder.

Usage: sudo makeBootableInstaller.sh /path/to/installinstallmacos.py_output.dmg

Tested with High Sierra and Mojave dmgs.

### Concerns
I'm not happy with line 55 
```
hdiutil eject -quiet "/Volumes/Install macOS $osName 1"
```
but createinstallmedia changes the name of the volume (and doesn't output the name prior to macOS Mojave), and it should always match what the installer volume is called, so I think this should continue to work.
