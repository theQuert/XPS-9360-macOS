## XPS 9360 Mojave 10.14.4 (18E226)


  - Device  : Dell XPS 13 9360                                                           
  - CPU     : Intel i7-8550U                                                             
  - GPU     : Intel UHD 620                                                              
  - Ram     : SK Hynix 16GB 2133 MHz LPDDR3                                                   
  - Sound   : ALC256 (ALC3246)                                                           
  - SSD     : [WD Black SN750 (WDS100T3X0C) 1TB NVMe PCIe SSD](https://www.amazon.com/BLACK-SN750-500GB-Internal-Gaming/dp/B07MH2P5ZD)                                                      
  - Display : FHD (1920x1080)
  - Webcam  : UVC Camera VendorID_3034 ProductID_22155
  - Wifi-Card : Swapped the original `Killer 1535` with [`BCM94352z(DW1560)`](https://www.amazon.com/Broadcom-BCM94352Z-802-11a-Bluetooth-867Mbps/dp/B0156DVQ7G/ref=sr_1_2?keywords=dw1560&qid=1558493816&s=electronics&sr=1-2)                    
  - Thunderbolt 3 Dongle : [Dell DA300](https://www.amazon.com/Dell-DA300-USB-C-Mobile-Adapter/dp/B079MDQDP4)                                                   
## Not Work
- Fingerprint Sensor
- Card Reader
- FaceTime
- Messages

## Device Firmware
- BIOS Version: BIOS `2.8.1`
- Thunderbolt Version: `NVM 26`

## Clover Firmware
- Clover `r4934`

## Before Installation
#### Make Bootable Installation Drive - macOS with Clover
  - Download the version you like from [Disk_Image](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/), then burn the image with [Etcher](https://www.balena.io/etcher/) to your USB drive.
  - Then, use [DiskGenius](http://www.diskgenius.cn/download.php) open EFI partition of the USB drive.
  - According to `README.md` in the `/EFI/CLOVER/kexts/Other` from EFI partition of the installation drive, remove the kexts mentioned from `/EFI/CLOVER/kexts/Other`

#### DVMT
  - Enter `BIOS/Boot Sequence`  add `Boot Entry` with `CLOVER/tools/DVMT.efi` , then run the following commands
```
  setup_var 0x4de 0x00  // Disable CFG Lock
  setup_var 0x785 0x06  // Increase DVMT pre-allocated size to 192M For FHD version, it's also recommended setting to 192M
  setup_var 0x786 0x03  // Increase CFG Memory to maximum
```

#### Format SSD with 4K sectors for `APFS` - You would need to make a Linux Bootable Drive
  - Choose any Linux distribution you like, I prefer [Ubuntu](https://www.ubuntu.com/download/desktop)
  - Under Windows environment, you need to burn [Ubuntu](https://www.ubuntu.com/download/desktop) Disk image to USB Drive.
  - Boot with the Linux bootable drive.
  - using `nvme-cli` formatting into `4K sectors` to work better with `APFS`, see the giude
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

  ## You may receive the messages below during installation...
  #### `Fail to erase the disk you choose to install macOS`
  ##### To solve the problem, you have to show up `All Devices` before erasing, then erase the whole disk with `APFS`.
  #### `The macOS installation couldn't be completed.`
  #### To solve the problem, just IGNORE it. Then, REBOOT again. You will see the new entry has shown up in the `Clover Interface`.
  ### If the system still fail to boot with the entry, please install the whole system again.

  ## Things to FIX after Boot into the System

 #### 1. Download and Installation the [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), then Mount EFI partition with it.

 #### 2. Copy the whole Folders and Files from this repository to your EFI partition, then your Hackintosh can boot without USB Installer.

 #### 3. Enter the `BIOS/Boot Sequence` adding new entry with path `/EFI/EFI/CLOVER/CLOVERX64.efi`

 #### 4. Activate the Wifi and Bluetooth functions for `BCM94352Z`, if not using this card you may remove the kexts below and unfollow Step 5.
 The kexts for `BCM94352z` has already put in
- /CLOVER/kexts/Other/BrcmFirmwareRepo.kext
- /CLOVER/kexts/Other/BrcmPatchRAM2.kext  
- /CLOVER/kexts/Other/AirportBrcmFixup.kext  

 #### 5. You still have to copy the kexts from path `/BCM94352Z/BrcmFirmwareRepo.kext` `/BCM94352Z/BrcmPatchRAM2.kext` to `/Library/Extensions`, and then running `/tools/Kext Utility` to fix the permission. Which may enhance the stability for Wifi & Bluetooth.
 ##### If you boot with [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/) rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), I have put the three kexts above to `/OC/Kexts` already, but you still have to copy the three kext above to `/Library/Extensions`, and then running `/tools/Kext Utility` to fix the permission.

 #### 6. Change your `SMBIOS` Serial number of your Hackintosh
- Install [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), then Open `/CLOVER/config.plist` with `Clover Configurator`, enter the `SMBIOS Mode`.
- Then, generate new `Serial Number`, `SMUUID`, save the changes ---> REBOOT
 ##### If you boot with [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/) rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), install [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/), then enter `SMBIOS` doing same things above.

 #### 7. Running `XPS9360.sh` with the instructions below
   -  After Mount the EFI partition with Clover Configurator or running the following commands in Terminal below
   -  Find the disk name of you EFI partition with the command
   ```BASH
      sudo diskutil list
   ```
   -  Mount the disk name of your EFI partition with the command
   ```BASH
      sudo diskutil mount /dev/disk0s1   //The position of your EFI partition
   ```
   -  Running `XPS9360.sh` to Compile `DSDT`
   ```BASH
      bash /Volumes/EFI/EFI/XPS9360.sh --compile-dsdt
   ```
   -  Running `XPS9360.sh` to Enable Third Party Application
   ```BASH
      bash /Volumes/EFI/EFI/XPS9360.sh --enable-3rdparty
   ```
   -  Running `XPS9360.sh` to Disable Touch ID for the Fingerprint couldn't work on Hackintosh
   ```BASH
      bash /Volumes/EFI/EFI/XPS9360.sh --disable-touchid
   ```

   ## Enable TRIM on Hackintosh
   Although it's set Native TRIM support with the settings on this installation, if it's disabled, run the commands below.
   ```BASH
   sudo trimforce enable
   ```

   ## Fixing the Headset Jack
  Running the below commands to fix Headset Jack
   ```BASH
      bash /Volumes/EFI/EFI/ComboJack/install.sh
   ```

   ## For Better Sleep
   Run the Commands below:
   ```BASH
    sudo pmset -a hibernatemode 0
 	  sudo pmset -a autopoweroff 0
 	  sudo pmset -a standby 0
 	  sudo rm /private/var/vm/sleepimage
 	  sudo touch /private/var/vm/sleepimage
 	  sudo chflags uchg /private/var/vm/sleepimage
   ```
   ## For Better Using Experience
 You may need
   - [BetterSnapTool](https://itunes.apple.com/tw/app/bettersnaptool/id417375580?mt=12) to arrange the position of the windows on screen better.
   - [Bartender](https://www.macbartender.com/) to add/remove the icon showing on the status bar.
   - [FruitJuice](https://fruitjuiceapp.com/) to monitor the battery status and usage time.
   - [Xclient](https://xclient.info) to download some software, for testing purpose.
   - [Macxin](https://macxin.com) to download some software, for testing purpose.
   - [Cyberduck](https://cyberduck.io/) to access your Cloud Storage and FTP Server.
   - [Transmit](https://panic.com/transmit/) to access your Cloud Storage and FTP Server.
   - [Atom](https://atom.io/) to edit profile and programming.
   - [XDM](http://xdman.sourceforge.net/) works as a downloader on macOS.
   - [Carbon Copy Cloner](https://bombich.com/download) When you want to swap your SSD.

   ## Custom setting the delay between trackpad and keyboard
   To do that you need to edit Info.plist in VoodooI2CHID.kext:
   - Open the `Info.plist` in the `VoodooI2CHID.kext` with any Text Editor(I use [Atom](https://atom.io/))
   - Finding the `QuietTimeAfterTyping`
   - Changing the `value` you like
   #### I have preset the `value` to `0`

   ## HiDPI
   Using [one-key-HiDPI](https://github.com/xzhih/one-key-hidpi)

   ## Optional Settings
   #### IF you have the same CPU as mine, we can do the Undervolting settings below.
   #### Warning!!! This may cause crash on your device, please be aware.
 Enter `BIOS/Boot Sequence` then add new Boot with `CLOVER/tools/DVMT.efi`, run the following commands
 - Overclock, CFG, WDT & XTU enable
 ```BASH
        setup_var 0x4DE 0x00
        setup_var 0x64D 0x01
        setup_var 0x64E 0x01
 ```
 - Undervolting values:
 ```BASH
        setup_var 0x653 0x64     // CPU: -100 mV
        setup_var 0x655 0x01     // Negative voltage for 0x653
        setup_var 0x85A 0x1E     // GPU: -30 mV
        setup_var 0x85C 0x01     // Negative voltage for 0x85A
```
   ## Things to do if you swap the SSD after using for a while...(Optional settings)
   #### Format SSD with 4K sectors for `APFS`
  - You would need to make a Linux Bootable Drive
  - Choose any Linux distribution you like, I prefer [Ubuntu](https://www.ubuntu.com/download/desktop)
  - You need to burn [Ubuntu](https://www.ubuntu.com/download/desktop) Disk image to USB Drive, then boot with it.
  - using `nvme-cli` formatting into `4K sectors` to work better with `APFS`, see the giude
         https://www.tonymacx86.com/threads/guide-sierra-on-hp-spectre-x360-native-kaby-lake-support.228302/
   #### Time to clone system and data to the new SSD
  - You will need an external NVMe reader to carry your new SSD as a external drive.
  - Under Hackintosh environment, using `Disk Utility` format your new SSD as `APFS` format.
  - Using [Carbon Copy Cloner](https://bombich.com/download), to clone the whole System Disk to your new drive.
  - When [Carbon Copy Cloner](https://bombich.com/download) done, you can set your `Startup Disk` to the new SSD drive to test if it works fine.
  -  If it works fine, shutdown the system, and use the screw to swap your SSD with the new one.
  -  Now, it's time to enjoy...

   ## Credits
   #### [the-darkvoid](https://github.com/the-darkvoid/XPS9360-macOS)
   #### [ComboJack](https://github.com/hackintosh-stuff/ComboJack)
   #### [HiDPI](https://github.com/xzhih/one-key-hidpi)
   #### [OpenCore-Configurator](https://github.com/notiflux/OpenCore-Configurator)
   #### [Disk_Image](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/)
   #### [daliansky](https://github.com/daliansky)
   #### [Leo Neo Usfsg](https://www.facebook.com/yuting.lee.leo)
   #### Kexts version and authors are mentioned in [kexts_info.txt](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/kexts_info.txt)
