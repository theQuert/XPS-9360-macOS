# macOS on XPS 13 9360
#### This repo is currently compatible with macOS versions as below...
|   macOS Catalina    |     macOS Mojave     |   macOS High Sierra   |
|---------------------|----------------------|-----------------------|
|   10.15.2  (19C57)  |   10.14.6  (18G87)   |   10.13.6  (17G2112)  |
|   10.15.1  (19B88)  |   10.14.5  (18F132)  |   10.13.6  (17G65)    |
|   10.15    (19A583) |   10.14.4  (18E226)  |                       |
|                     |   10.14.3  (18D42)   |                       |
|                     |   10.14.2  (18C54)   |                       |
|                     |   10.14.1  (18B75)   |                       |
|                     |   10.14    (18A389)  |                       |

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
  - Dual-Boot OS: macOS Catalina `10.15.2 (19C57)` & Ubuntu `18.04 LTS`

## Device Firmware
- BIOS Version: `2.8.1`
- Thunderbolt Version: `NVM 26`

## Clover Firmware
- Clover `r5102`

## Pre-Installation
#### Create bootable USB installer:
  - Goto [Download Link](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/), and download the version you prefer.
  - Make bootable drive with [balenaEtcher](https://www.balena.io/etcher/).
  - Copy the whole repository to replace erverything in  EFI partition.
#### DVMT
  - Enter `BIOS/Boot Sequence`, add `Boot Entry` with `CLOVER/tools/DVMT.efi` , then run the following commands
```
  setup_var 0x4de 0x00  // Disable CFG Lock
  setup_var 0x785 0x06  // Increase DVMT pre-allocated size to 192M For FHD version, it's also recommended setting to 192M
  setup_var 0x786 0x03  // Increase CFG Memory to maximum
```

#### Format SSD with 4K sectors for `APFS` - Creating a Linux bootable drive is needed.
  - Choose any Linux distribution you like, I prefer [Ubuntu](https://www.ubuntu.com/download/desktop)
  - Formatting SSD into `4K sectors` with `nvme-cli` to work better with `APFS`, see the guide
      https://www.tonymacx86.com/threads/guide-sierra-on-hp-spectre-x360-native-kaby-lake-support.228302/
#### Get compatible with LITEON and PLEXTOR SSD - If you are not using with LITEON or PLEXTOR SSD, skip this step.
  - To solve the problem, `config.plist` with patches is needed.
  - The `config.plist` with patches is under the path [config for LITEON](https://github.com/the-Quert/XPS-9360-macOS/tree/master/CLOVER/config_for_LITEON).
  - Rename to `config.plist` and try one at each time, one of them would be capatible with your SSD.

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

  - Disable Camera (Optional)

  ## Post-Installation

  -  Copy all folders and files from this repository to EFI partition, for booting without USB purpose.

  -  Enter `BIOS/Boot Sequence` , and adding new entry with path `/EFI/CLOVER/CLOVERX64.efi`

  -  To activate Wifi and Bluetooth functions for `DW1560`, follow next step, or skip it.

  - Cpoying kexts from path `/DW1560`  to `/Library/Extensions` is needed, and then running command to rebuild cache.
   ```BASH
      bash /Volumes/EFI/XPS.sh --rebuild-cache
   ```
 ##### If booting with [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/) rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), the three kexts above has existed in `/OC/Kexts` already, you still have to copy them to `/Library/Extensions`, and then running previous command to rebuild cache.

  -  Change  `SMBIOS` settings for your device
      - With [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), enter the `SMBIOS Mode` of `config.plist`.
      - Generate new `Serial Number`, `SMUUID`, save the changes ---> REBOOT
 ##### If booting with [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/) rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), install [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/), then enter `SMBIOS` to do same things above.

  ## Running shell script in Terminal with the following instructions...
   -  After mounting the EFI partition with Clover Configurator or running the following commands below in terminal..
   -  Mount EFI partition with the command below
   ```BASH
      sudo diskutil mount /dev/disk0s1
   ```
   -  Running `XPS.sh` to Compile `DSDT`
   ```BASH
      bash /Volumes/EFI/XPS.sh --compile-dsdt
   ```
   -  Running `XPS.sh` to Allow 3rd party Applications to install on macOS
   ```BASH
      bash /Volumes/EFI/XPS.sh --enable-3rdparty
   ```
   -  Running `XPS.sh` to fix Headphone Jack
   ```BASH
      bash /Volumes/EFI/XPS.sh --combo-jack
   ```
   -  Running `XPS.sh` to enable TRIM support on SSD
   ```BASH
      bash /Volumes/EFI/XPS.sh --enable-trim
   ```
   -  Running `XPS.sh` to rebuild cache
   ```BASH
      bash /Volumes/EFI/XPS.sh --rebuild-cache
   ```
   -  Running `XPS.sh` to enable better sleep support
   ```BASH
      bash /Volumes/EFI/XPS.sh --better-sleep
   ```
   -  Running `XPS.sh` to Disable 4-Digit Pin Required on macOS
   ```BASH
      bash /Volumes/EFI/XPS.sh --pin-custom
   ```

   ## Fix the buzz sound from headphone jack
  ```
    Open System Preferences/Sound/Input
```

   ## SMBIOS
   - Default SMBIOS settings of this repo is `MacbookPro15,2`.
   - After testing, performance is working same as `MacbookPro14,1`.
   - If you prefer `MacbookPro14,1`, corresponded `config.plist` are provided [here](https://github.com/the-Quert/XPS-9360-macOS/tree/master/CLOVER/config_for_other_SMBIOS).
   - `Serial Number` and `SmUUID` are erased beforehand, you need to generaete on your own.

   ## CPUFriend
   - The kexts and SSDT for `i7-8550U` has put [here](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CPUFriend/i7-8550U), by working SMBIOS with `MacbookPro15,2`.
   - You have to put `CPUFriend.kext` & `CPUFrindDataProvider.kext` in both `/CLOVER/kexts/Other` and `Library/Extensions`, then [rebuild cache](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/Commands/rebuild_cache.sh).
   - Furthermore, you also have to put `SSDT-CPUF.aml` in `/CLOVER/ACPI/patched` for working as normal after awake.

   #### If your `config.plist` works with `MacbookPro14,1` , corresponding kexts and SSDT are put in [folder](https://github.com/the-Quert/XPS-9360-macOS/tree/master/CPUFriend/i7-8550U) as well.
   #### If you need to generate new CPUFriend kexts, refer to [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands), and follow this [link](https://github.com/acidanthera/CPUFriend)

   ## Custom setting the delay between trackpad and keyboard
   To do that you need to edit `Info.plist` in `VoodooI2CHID.kext`:
   - Open the `Info.plist` in the `VoodooI2CHID.kext` with any Text Editor(I use [Atom](https://atom.io/))
   - Finding the `QuietTimeAfterTyping`
   - Changing the `value` you prefer
   #### I have preset the `value` to `0`

   ## More Custom Settings
   Refer to [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands) for more customization.

   ## HiDPI
   - Use [one-key-HiDPI](https://github.com/xzhih/one-key-hidpi)

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

   ### TODO for upgrading macOS
  - Before upgrading, remember to prepare external hard drive to backup with `Time Machine`.
  - Creating bootable USB drive with the version of macOS you prefer. [[Download Link]](https://mirrors.dtops.cc/iso/MacOS/daliansky_macos/)   [[balenaEtcher]](https://www.balena.io/etcher/)
  - After booting sucessfully, copy the whole repo to you EFI partition. (The commands to mount EFI partition is provided above.)
  - If you use `DW1560`, follow the [guide](https://github.com/the-Quert/XPS-9360-macOS/blob/master/README.md#things-to-fix-after-booting-into-the-system-successfully).
  - Follow the guide below to [Fix the Headset Jack](https://github.com/the-Quert/XPS-9360-macOS/blob/master/README.md#fix-the-headset-jack), and [For Better Sleep](https://github.com/the-Quert/XPS-9360-macOS/blob/master/README.md#for-better-sleep).
  - Follow the guide to set your [CPUFriend](https://github.com/the-Quert/XPS-9360-macOS/blob/master/README.md#cpufriend).
  - Recovery you data and settings which you backup through `Time Machine` before with `Migration Assistant`.
   
   ## Experimental part below is for developers and those who want to dig in more...
   ### External Display Support
   - According to [ioregistryExplorer](https://github.com/vulgo/IORegistryExplorer), `Framebuffer@0 (Connector 0) ` is LVDS (Internal Display).
   - `Framebuffer@1 (Connector 1)`, `Framebuffer@2 (Connector 2)` are pointing to DisplayPort and HDMI respectively.
   - HDMI video output is working as normal, but Audio With HDMI is not working yet.
   - Info...
  ```
       ID: 59160000, STOLEN: 34 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00000B0B
       TOTAL STOLEN: 35 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 103 MB, MAX OVERALL: 104 MB (109588480 bytes)
       GPU Name: Intel HD Graphics 620
       Model Name(s): MacBookPro14,2
       Camelia: Disabled, Freq: 1388 Hz, FreqMax: 1388 Hz
       Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3
       [0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000098 - LVDS
       [1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x00000187 - DP
       [2] busId: 0x04, pipe: 10, type: 0x00000800, flags: 0x00000187 - HDMI
          00000800 02000000 98000000
          01050900 00040000 87010000
          02040A00 00080000 87010000
```
  - Maybe problem with `framebuffer@2` or SMBIOS need to be earlier than `MacbookPro15,1`.
  ### Boot Arguments
   - `darkwake=4`
      The `darkwake` flag has to do with sleep. More information can be found in this [thread](https://www.tonymacx86.com/threads/important-darkwake-0-flag-can-break-auto-sleep-in-10-8-1.69714/#post-447117).
   - `igfxcflbklt=opcode`
      To work with `WhateverGreen.kext`, fixing BackLight.
   - `brcmfx-country=XX`
      Change the country code to XX (US, CN, #a, ...) For Broadcom WiFi card.
   - `brcmfx-country=#a`
      Enables 80MHz wide channels on the 5GHz spectrum. For Broadcom WiFi card.

   ## Credits
   #### [ComboJack](https://github.com/hackintosh-stuff/ComboJack)
   #### [CPUFriend](https://github.com/acidanthera/CPUFriend)
   #### [HiDPI](https://github.com/xzhih/one-key-hidpi)
   #### [OpenCore-Configurator](https://github.com/notiflux/OpenCore-Configurator)
   #### Download link provided by [daliansky](https://github.com/daliansky)
   #### [Leo Neo Usfsg](https://www.facebook.com/yuting.lee.leo)
   #### Kexts version and developers are mentioned in [kexts_info.txt](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/kexts_info.txt)
