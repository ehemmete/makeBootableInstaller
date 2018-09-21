# makeBootableInstaller
Create a dmg for bootable macOS installers from installinstallmacos.py output

This script takes a .dmg from installinstallmacos.py (https://github.com/munki/macadmin-scripts/blob/master/installinstallmacos.py) as input and outputs a dmg of createinstallmedia output suitable for restoring to a USB drive.

Usage: sudo makeBootableInstaller.sh /path/to/installinstallmacos.py_output.dmg
