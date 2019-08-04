#!/usr/bin/env bash

hdiutil attach -owners on origin.dmg -shadow
//edit EFI
hdiutil detach /dev/diskx
hdiutil convert -format UDZO -o  new_file.dmg origin.dmg -shadow
