# macOS Mojave XPS13 9360 
## XPS 9360 Mojave 10.14.4 (18E226)

#### Last_Update: `20190519`

- Device:     Dell XPS 13 9360
- CPU:        i7-8550U
- Graphics:   Intel UHD 620
- Sound:      ALC256 (ALC3246)
- SSD:        Sk-hynix PC401
- Screen:     1080P FHD
- Wifi-Card:  Swap the Original Killer 1535 with BCM94352z(DW1560)
- Thunderbolt 3 Dongle: Dell DA300

## Not Work
1. Fingerprint Sensor
2. Card Reader
3. FaceTime
4. Messages

## DeviceFirmware
- BIOS Version: BIOS `2.8.1`
- Thunderbolt Version: `NVM 26`

## Clover Firmware
- Clover `r4920`

## Before Installation
#### Make Bootable Installation Drive
  - Download the version you like from [Disk_Image](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/), then burn the image with [Etcher](https://www.balena.io/etcher/) to your USB drive.
  - Then, use [DiskGenius](http://www.diskgenius.cn/download.php) to open the EFI partition of the USB drive.
  - Following the `Readme.md` in the EFI partition, to remove the essential kexts in `CLOVER/kexts/Other`
  
#### DVMT
  - Enter `BIOS/Boot Sequence`  add new Boot with `/tool/DVMT.efi` , then run the following commands
```
  setup_var 0x4de 0x00 (Disable CFG Lock)
  setup_var 0x785 0x06 (Increase DVMT pre-allocated size to 192M For FHD version, it's also recommanded set to 192M)
  setup_var 0x786 0x03 (Increase CFG Memory to maximum)
```
#### SSD to 4k sector
  You need any Linux version to create bootable USB
  - using `nvme-cli` formatting into 4k sector to work better with `APFS`, see the giude 
      https://www.tonymacx86.com/threads/guide-sierra-on-hp-spectre-x360-native-kaby-lake-support.228302/

#### BIOS settings
  - Sata: AHCI

  - Enable SMART Reporting

  - Disable thunderbolt boot and pre-boot support

  - USB security level: disabled

  - Enable USB powershare

  - Enable Unobtrusive mode

  - Disable SD card reader (saves 0.5W of power)

  - TPM Off

  - Deactivate Computrace

  - Enable CPU XD

  - Disable Secure Boot

  - Disable Intel SGX

  - Enable Multi Core Support

  - Enable Speedstep

  - Enable C-States

  - Enable TurboBoost

  - Enable HyperThread

  - Disable Wake on USB-C Dell Dock

  - Battery charge profile: Standard

  - Numlock Enable

  - FN-lock mode: Disable/Standard

  - Fastboot: minimal

  - BIOS POST Time: 0s

  - Enable VT

  - Disable VT-D

  - Wireless switch OFF for Wifi and BT

  - Enable Wireless Wifi and BT

  - Allow BIOS Downgrade

  - Allow BIOS Recovery from HD, disable Auto-recovery

  - Auto-OS recovery threshold: OFF

  - SupportAssist OS Recovery: OFF
  
  ## Things to FIX after Boot into the System
 
 #### 1. Download and Installation the `Clover Configurator`, then Mount EFI partition with it.
 
 #### 2. Copy the whole Folders and Files from this repository to your EFI partition, then your Hackintosh can boot without USB Installer.
 
 #### 3. Enter the `BIOS/Boot Sequence` adding new entry with path:
 - /EFI/EFI/CLOVER/CLOVERX64.efi
 
 #### 4. Activate the Wifi and Bluetooth functions
    The kexts for `BCM94352z` has already put in 
    - /CLOVER/kexts/Other/BrcmFirmwareData.kext
    - /CLOVER/kexts/Other/BrcmPatchRAM2.kext  
    - /CLOVER/kexts/Other/AirportBrcmFixup.kext  
 
 #### 5. You have to copy the three kext above to `/Library/Extensions`, and then running `/tools/Kext Utility` to fix the permission. Which can fix the Wifi, Bluetooth 
 ##### If you boot with OpenCore Configurator rather than Clover, I have put the three kexts above to `/OC/Kexts` already.
 
 #### 6. Change your `SMBIOS` Serial number for your Hackintosh
    - Install CLover Configurator, then Open `/CLOVER/config.plist` with `Clover Configurator`, enter the `SMBIOS Mode`.
    - Then, generate new `Serial Number`, `SMUUID`, and save the changes.---> Then REBOOT
 ##### If you boot with `OpenCore Configurator` rather than `Clover`, just Install `OpenCore Configutrator`, and enter `SMBIOS` then do the same things above.
  
 #### 7. Running `XPS9360.sh`
   -  After Mount the EFI partition with Clover Configurator or running the following commands in Terminal below
   -  Find the disk name of you EFI partition with the command
   ```BASH
      sudo diskutil list
   ```
   -  Mount the disk name of your EFI partition with the command
   ```
      sudo diskutil mount /dev/disk?s?   ///The position of your EFI partition 
   ```
   -  Running `XPS9360.sh` to Compile `DSDT`
   ```
      bash /Volumes/EFI/EFI/XPS9360.sh --compile-dsdt 
   ```
   -  Running `XPS9360.sh` to Enable Third Party Application
   ```
      bash /Volumes/EFI/EFI/XPS9360.sh --enable-3rdparty
   ```
   -  Running `XPS9360.sh` to Disable Touch ID for the Fingerprint couldn't work on Hackintosh
   ```
      bash /Volumes/EFI/EFI/XPS9360.sh --disable-touchid
   ```
   
   ## Fixing the Headset Jack 
   - Running the below commands to fix Headset Jack
   ```BASH
      bash /Volumes/EFI/EFI/ComboJack/install.sh
   ```
   
   ## For Better Sleep
   Run the Commands below:
   ```
    sudo pmset -a hibernatemode 0
 	  sudo pmset -a autopoweroff 0
 	  sudo pmset -a standby 0
 	  sudo rm /private/var/vm/sleepimage
 	  sudo touch /private/var/vm/sleepimage
 	  sudo chflags uchg /private/var/vm/sleepimage
    
   ```
   ## For Better Using Experience
   You may need 
   - `BetterSnapTool` to arrange the position of the windows on screen better.
   - `Bartender` to add/remove the icon showing on the status bar.
   - `FruitJuice` to monitor the battery status and usage time.
   - [Xclient](xclient.info) to download some software, for testing purpose.
   - [Macxin](macxin.com) to download some software, for testing purpose.
   
   ## For disable the delay between trackpad and keyboard 
      To do that you need to edit Info.plist in VoodooI2CHID.kext:
      - Open the info.plist in the VoodooI2CHID.kext with any Text Editor
      - Finding the `QuietTimeAfterTyping`
      - Changing the value you like
   #### I have preset the value to `0`
    
   ## HIDPI on Hackintosh
   Using `one-key-HIDPI`, Link is on below
      https://github.com/xzhih/one-key-hidpi
  
   ## Optional Settings
   ### IF you have the same CPU as mine, we can do the Undervolting settings below.
   ## Warning!!! This may cause crash on your device, please be aware.
```
    Enter BIOS/Boot_Sequence then add new Boot with /tool/DVMT.efi , then run the following commands
    (1) Overclock, CFG, WDT & XTU enable
        setup_var 0x4DE 0x00
        setup_var 0x64D 0x01
        setup_var 0x64E 0x01
    (2) Undervolt values:
        setup_var 0x653 0x64     (CPU: -100 mV)
        setup_var 0x655 0x01     (Negative voltage for 0x653)
        setup_var 0x85A 0x1E     (GPU: -30 mV)
        setup_var 0x85C 0x01     (Negative voltage for 0x85A)
``` 
    
   ## Credits
   ### [the-darkvoid](https://github.com/the-darkvoid/XPS9360-macOS)
   ### [ComboJack](https://github.com/hackintosh-stuff/ComboJack)
   ### [HIDPI](https://github.com/xzhih/one-key-hidpi)
   ### [Original_Image](https://blog.daliansky.net/macOS-Mojave-10.14.4-18E226-official-version-with-Clover-4903-original-image.html)
   ### [Disk_Image](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/)
   ### [daliansky](https://github.com/daliansky)
   ### [Leo Neo Usfsg](https://www.facebook.com/yuting.lee.leo)
