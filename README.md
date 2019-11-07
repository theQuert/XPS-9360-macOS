# macOS on XPS 13 9360
## macOS Mojave 10.14.6 (18G95)

  - Device  : Dell XPS 13 9360                                                           
  - CPU     : Intel i7-8550U                                                             
  - GPU     : Intel UHD 620                                                              
  - RAM     : SK Hynix 16GB 2133 MHz LPDDR3                                                   
  - Sound   : ALC256 (ALC3246)                                                           
  - SSD     : [WD Black SN750 (WDS100T3X0C) 1TB NVMe PCIe SSD](https://www.amazon.com/BLACK-SN750-500GB-Internal-Gaming/dp/B07MH2P5ZD)                                                      
  - Display : FHD (1920x1080) on XPS | QHD (2560x1440) on external display (CHIMEI 27P10Q)
  - Webcam  : UVC Camera VendorID_3034 ProductID_22155
  - Wifi-Card : Swapped the original `Killer 1535` with [`DW1560`](https://www.amazon.com/Broadcom-BCM94352Z-802-11a-Bluetooth-867Mbps/dp/B0156DVQ7G/ref=sr_1_2?keywords=dw1560&qid=1558493816&s=electronics&sr=1-2)                    
  - Thunderbolt 3 Dongle : [Dell DA300](https://www.amazon.com/Dell-DA300-USB-C-Mobile-Adapter/dp/B079MDQDP4)                                                   

## Device Firmware
- BIOS Version: BIOS `2.8.1`
- Thunderbolt Version: `NVM 26`

## Clover Firmware
- Clover `r5096`

## Pre-Installation
#### DVMT
  - Enter `BIOS/Boot Sequence`, add `Boot Entry` with `CLOVER/tools/DVMT.efi` , then run the following commands
```
  setup_var 0x4de 0x00  // Disable CFG Lock
  setup_var 0x785 0x06  // Increase DVMT pre-allocated size to 192M For FHD version, it's also recommended setting to 192M
  setup_var 0x786 0x03  // Increase CFG Memory to maximum
```

#### Format SSD with 4K sectors for `APFS` - You would need to make a Linux Bootable Drive
  - Choose any Linux distribution you like, I prefer [Ubuntu](https://www.ubuntu.com/download/desktop)
  - Boot with the Linux bootable drive.
  - using `nvme-cli` formatting SSD into `4K sectors` to work better with `APFS`, see the guide
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

  - Disable Camera

  ## Things to fix after boot into the system successfully

 #### 1. Download and install [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), then mount EFI partition.

 #### 2. Copy the whole folders and files from this repository to EFI partition, for booting without USB purpose.

 #### 3. Enter the `BIOS/Boot Sequence` adding new entry with path `/EFI/EFI/CLOVER/CLOVERX64.efi`

 #### 4. Activate Wifi and Bluetooth functions for `DW1560`, follow Step 5, or skip to step 6.
 The kexts for `DW1560` have already put in the folder `/DW1560`

 #### 5. You have to copy the kexts from path `/DW1560`  to `/Library/Extensions`, and then running  [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands/rebuild_cache.sh)to fix the permission. Which may enhance the stability for Wifi & Bluetooth.
 ##### If booting with [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/) rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), the three kexts above has existed in `/OC/Kexts` already, you still have to copy them to `/Library/Extensions`, and then running `/tools/Kext Utility` to fix the permission.

 #### 6. Change your `SMBIOS` settings for your device
- Install [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), then Open `/CLOVER/config.plist` with `Clover Configurator`, enter the `SMBIOS Mode`.
- Generate new `Serial Number`, `SMUUID`, save the changes ---> REBOOT
 ##### If booting with [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/) rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), install [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/), then enter `SMBIOS` to do same things above.

 #### 7. Running `XPS9360.sh` with the instructions as below
   -  After mounting the EFI partition with Clover Configurator or running the following commands in Terminal below
   -  Find the disk name of EFI partition with the command
   ```BASH
      sudo diskutil list
   ```
   -  Mount EFI partition with the command
   ```BASH
      sudo diskutil mount /dev/disk0s1
   ```
   -  Running `XPS9360.sh` to Compile `DSDT`
   ```BASH
      bash /Volumes/EFI/XPS9360.sh --compile-dsdt
   ```
   -  Running `XPS9360.sh` to Enable Third Party Application
   ```BASH
      bash /Volumes/EFI/XPS9360.sh --enable-3rdparty
   ```
   -  Running `XPS9360.sh` to Disable Touch ID for the Fingerprint couldn't work on Hackintosh
   ```BASH
      bash /Volumes/EFI/XPS9360.sh --disable-touchid
   ```

   ## Enable Trim on SSD
   Although it's set Native TRIM support with the settings on this installation, if it's disabled, run the commands below.
   ```BASH
   sudo trimforce enable
   ```

   ## Fix the Headset Jack
  Running the below commands to fix Headset Jack
   ```BASH
      bash /Volumes/EFI/ComboJack/install.sh
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

   ## CPUFriend
   - The kexts and SSDT for i7-8550U has put in [here](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CPUFriend/i7-8550U), by using SMBIOS with MacbookPro 14,1.
   - You have to put [CPUFriend.kext](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CPUFriend/i7-8550U/CPUFriend_14%2C1/CPUFriend.kext) & [CPUFrindDataProvider.kext](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CPUFriend/i7-8550U/CPUFriend_14%2C1/CPUFriendDataProvider.kext/Contents) in both [/CLOVER/kexts/Other](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CLOVER/kexts/Other) and L/E, then [rebuild cache](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/Commands/rebuild_cache.sh).
   - Furthermore, you also have to put [SSDT-CPUF.aml](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/CPUFriend/i7-8550U/CPUFriend_14%2C1/SSDT-CPUF.aml) into [/CLOVER/ACPI/patched](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CLOVER/ACPI/patched) for working normal after awake.

   #### If your [config.plist](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/CLOVER/config.plist) works with MacbookPro 15,2 , I have put corresponding kexts and SSDT in the [folder](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CPUFriend/i7-8550U/CPUFriend_15%2C2) as well.
   #### If you need to generate new CPUFriend kexts, refer to [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands), and follow this [link](https://github.com/acidanthera/CPUFriend).

   ## For Better Using Experience
 You may need
   - [BetterSnapTool](https://itunes.apple.com/tw/app/bettersnaptool/id417375580?mt=12) to arrange the position of the windows on screen better.
   - [Bartender](https://www.macbartender.com/) to add/remove the icon showing on the status bar.
   - [FruitJuice](https://fruitjuiceapp.com/) to monitor the battery status and usage time.
   - [Xclient](https://xclient.info) to download some software, for testing purpose.
   - [Macxin](https://macxin.com) to download some software, for testing purpose.
   - [Transmit](https://panic.com/transmit/) to access your Cloud Storage and FTP Server.
   - [Atom](https://atom.io/) to edit profile and programming.
   - [XDM](http://xdman.sourceforge.net/) works as a downloader on macOS.
   - [Carbon Copy Cloner](https://bombich.com/download) If you need swap the SSD.
   - [TurboBoost Switcher](http://tbswitcher.rugarciap.com/) To disable TurboBoost for extending battery duration time when on battery time.

   ## Custom setting the delay between trackpad and keyboard
   To do that you need to edit `Info.plist` in `VoodooI2CHID.kext`:
   - Open the `Info.plist` in the `VoodooI2CHID.kext` with any Text Editor(I use [Atom](https://atom.io/))
   - Finding the `QuietTimeAfterTyping`
   - Changing the `value` you like
   #### I have preset the `value` to `0`

   ## More Custom Settings
   Refer to [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands) for more customization.

   ## HiDPI
   Use [one-key-HiDPI](https://github.com/xzhih/one-key-hidpi)

   ## Optional Settings
   ### CPU Undervolting
   #### If having the same CPU as mine, you can do the undervolting settings below.
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
   ### Swapping SSD
  - You need an external NVMe reader to carry your new SSD as an external drive.
  - Under macOS environment, using `Disk Utility` format your new SSD as `APFS` format.
  - Using [Carbon Copy Cloner](https://bombich.com/download), to clone the whole System Disk to your new drive.
  -  If it works fine, shutdown the system, then swap your SSD with the new one.

   ## Credits
   #### [ComboJack](https://github.com/hackintosh-stuff/ComboJack)
   #### [CPUFriend](https://github.com/acidanthera/CPUFriend)
   #### [HiDPI](https://github.com/xzhih/one-key-hidpi)
   #### [OpenCore-Configurator](https://github.com/notiflux/OpenCore-Configurator)
   #### [Leo Neo Usfsg](https://www.facebook.com/yuting.lee.leo)
   #### Kexts version and authors are mentioned in [kexts_info.txt](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/kexts_info.txt)
