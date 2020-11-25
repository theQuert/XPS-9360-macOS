# macOS on XPS 13 9360
#### This repo is currently compatible with macOS versions as below...
|  macOS Big Sur   |   macOS Catalina     |     macOS Mojave     |   macOS High Sierra   |
|------------------|----------------------|----------------------|-----------------------|
|  11.0.1 (20B29)  |   10.15.7  (19H2)    |   10.14.6  (18G87)   |   10.13.6  (17G2112)  |
|                  |   10.15.6  (19G2021) |   10.14.5  (18F132)  |   10.13.6  (17G65)    |
|                  |   10.15.5  (19F2200) |   10.14.4  (18E226)  |                       |
|                  |   10.15.4  (19E287)  |   10.14.3  (18D42)   |                       |
|                  |   10.15.3  (19D76)   |   10.14.2  (18C54)   |                       |
|                  |   10.15.2  (19C57)   |   10.14.1  (18B75)   |                       |
|                  |   10.15.1  (19B88)   |   10.14    (18A389)  |                       |
|                  |   10.15    (19A583)  |                      |                       |
  - Device  : Dell XPS 13 9360    
  - CPU     : Intel i7-8550U                                                           
  - GPU     : Intel UHD 620 Kaby Lake                                                         
  - RAM     : SK Hynix 16GB 2133 MHz LPDDR3
  - Sound   : Realtek ALC256 (ALC3246)                                              
  - SSD     : [WD Black SN750 (WDS100T3X0C) 1TB NVMe PCIe SSD](https://www.amazon.com/BLACK-SN750-500GB-Internal-Gaming/dp/B07MH2P5ZD)                                     
  - Display : FHD (1920x1080) on XPS | QHD (2560x1440) on external display (CHIMEI 27P10Q)
  - Camera  : UVC Camera VendorID_3034 ProductID_22155
  - Wireless Card (3 options):     
  Swapped the original `Killer 1535` with [`BCM94360NG`](https://www.ebay.com/itm/Broadcom-BCM94360NG-WiFi-Card-better-than-DW1560-BT4-0-Adapter-802-11ac-1200Mbps-/283783627652).     
  Swapped the original `Killer 1535` with [`BCM94360CS2`](https://www.amazon.com/Broadcom-Bcm94360cs2-Bcm94360cs2ax-Bluetooth-Wireless/dp/B00PDNDQ0K).     
  Swapped the original `Killer 1535` with [`DW1560`](https://www.amazon.com/Broadcom-BCM94352Z-802-11a-Bluetooth-867Mbps/dp/B0156DVQ7G/ref=sr_1_2?keywords=dw1560&qid=1558493816&s=electronics&sr=1-2).     
  - Thunderbolt 3 Dongle : [Dell DA300](https://www.amazon.com/Dell-DA300-USB-C-Mobile-Adapter/dp/B079MDQDP4)
  - Dual-Boot OS: macOS Catalina `10.15.4 (19E287)` & Ubuntu `20.04 LTS`

## Device Firmware
- BIOS Version: `2.8.1` - `2.13.0`
- Thunderbolt 3 Version: `NVM 26`
- `BCM94360CS2` Bluetooth Version: `v150 c9318`
- `DW1560` Bluetooth Version: `v14 c5668` with BrcmPatch `v2.5.5`

## Bootloader Firmware
- Default bootloader: OpenCore `0.6.3` See more [info](https://github.com/the-Quert/XPS-9360-macOS/blob/master/README.md#Migrate-bootloader-from-Clover-to-OpenCore) about migration.
- No longer maintained: Clover `r5118`
## Pre-Installation
#### Create bootable USB installer: (Option 1 with gibMacOS)
  - Running [gibMacOS](https://github.com/corpnewt/gibMacOS), then download the version you prefer (gibMacOS script is allowed to download macOS images on all OS platforms with Python installed).
  - Copy the whole repository to EFI partition under path `/EFI` (You have to create an empty EFI directory, and put the whole repo in it).

#### Create bootable USB installer: (Option 2 with macOS through my shell script)
  - Running [macOS_downloader](https://github.com/the-Quert/XPS-9360-macOS/blob/master/Commands/macOS_downloader.sh) in Terminal. 
  - Choose `1) Download macOS`, then download the version you prefer.
  - Erase you USB drive with `Disk Utility`, and rename it to `Installer`.
  - Running [macOS_downloader](https://github.com/the-Quert/XPS-9360-macOS/blob/master/Commands/macOS_downloader.sh) in Terminal again.
  - Choose `2) Make bootable Media` .
  - Copy the whole repository to EFI partition under path `/EFI` (You have to create an empty EFI directory, and put the whole repo in it).

#### DVMT
  - Enter `BIOS/Boot Sequence` in `BIOS`, add `Boot Entry` with `/EFI/CLOVER/tools/DVMT.efi` , then run the following commands
```
  setup_var 0x4de 0x00  // Disable CFG Lock
  setup_var 0x785 0x06  // Increase DVMT pre-allocated size to 192M For FHD version, it's also recommended setting to 192M
  setup_var 0x786 0x03  // Increase CFG Memory to maximum
```

#### Format SSD with 4K sectors for `APFS` - Creating a Linux bootable drive is needed.
  - Choose any Linux distribution you like, I prefer [Ubuntu](https://www.ubuntu.com/download/desktop)
  - Formatting SSD to `4K sectors` with `nvme-cli`... for working better with `APFS`, see `Step 2` in this [guide](https://www.tonymacx86.com/threads/guide-sierra-on-hp-spectre-x360-native-kaby-lake-support.228302/).

#### Get compatible with LITEON and PLEXTOR SSD - If you are not using with LITEON or PLEXTOR SSD, skip it.
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

  -  Copy all folders and files from this repository to EFI partition.

  -  Enter `BIOS/Boot Sequence` , and adding new entry with path `/CLOVER/CLOVERX64.efi`

  -  To activate Wifi and Bluetooth functions for `DW1560`, follow next step, or skip it.

#### Wireless card - BCM94360CS2 Installation (If not using this card, skip it.)
  - To use this card, you need [BCM94360CS2](https://www.amazon.com/Broadcom-Bcm94360cs2-Bcm94360cs2ax-Bluetooth-Wireless/dp/B00PDNDQ0K), [Custom Adapter](amazon.com/gp/product/B07JFYSNVL/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1), and [Antenna Extended Cable](https://www.amazon.com/HUYUN-BCM94360CSAX-BCM94360CS2-BCM94360CS2AX-BCM94352Z/dp/B07L3DGJ2D/ref=redir_mobile_desktop?ie=UTF8&ref=ppx_pt2_mob_b_prod_image).
  - Wireless card installation:     
  Instruction with images: [here](https://github.com/the-Quert/XPS-9360-macOS/issues/16#issuecomment-612562283).
  - After installation, other modification is no needed.

#### Wireless card - BCM94360NG (If not using this card, skip it.)
  - Install directly, kexts and adapter are not needed.

#### Wireless card - DW1560 Installation (If not using this card, skip it.)
  -  Running following commands...
   ```BASH
      sudo diskutil mount /dev/disk0s1
      cd /Volumes/EFI/EFI
      cp -R DW1560/*.kext CLOVER/kexts/Other
      bash /Volumes/EFI/EFI/XPS.sh --rebuild-cache
   ```

##### If booting with `OpenCore` rather than [Clover Configurator](https://www.macupdate.com/app/mac/61090/clover-configurator), copy the three kexts above to `/EFI/OC/Kexts`, and then running previous command to rebuild cache.

### Running shell script in Terminal
   -  After mounting the EFI partition with Clover Configurator or running the following commands below in terminal..
   -  Mount EFI partition with the command below
   ```BASH
      sudo diskutil mount /dev/disk0s1
   ```
   -  Running `XPS.sh` to compile DSDT
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --compile-dsdt
   ```
   -  Running `XPS.sh` to Allow 3rd party Applications to install on macOS
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --enable-3rdparty
   ```
   -  Running `XPS.sh` to fix Headphone Jack
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --combo-jack
   ```
   -  Running `XPS.sh` to enable TRIM support on SSD
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --enable-trim
   ```
   -  Running `XPS.sh` to rebuild cache
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --rebuild-cache
   ```
   -  Running `XPS.sh` to enable better sleep support
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --better-sleep
   ```
   -  Running `XPS.sh` to Disable 4-Digit Pin Required on macOS
   ```BASH
      bash /Volumes/EFI/EFI/XPS.sh --pin-custom
   ```

## Fix the buzz sound from headphone jack
```
    Open System Preferences/Sound/Input
```

## Fix the "Webcam Black Screen" problem:
```
    sudo killall VDCAssistant
```
## SMBIOS
   - Default SMBIOS settings of this repo is `MacbookPro15,2`.
   - `Serial Number` and `SmUUID` are erased beforehand, you need to generaete on your own.

## CPUFriend
   - The kexts and SSDT for `i7-8550U` has put [here](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/CPUFriend/i7-8550U), by working SMBIOS with `MacbookPro15,2`.
   - You have to put `CPUFriend.kext` & `CPUFrindDataProvider.kext` in both `/CLOVER/kexts/Other` and `Library/Extensions`, then [rebuild cache](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/Commands/rebuild_cache.sh).
   - Furthermore, you also have to put `SSDT-CPUF.aml` in `/EFI/CLOVER/ACPI/patched` for working as normal after awake.

##### If you need to generate new CPUFriend kexts, refer to [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands), and follow [here](https://github.com/acidanthera/CPUFriend)

## Enable eGPU with Thunderbolt 3
   - You need to set `No Security` in TB3 BIOS option.
   - Stop `Clover` when it counts down during booting with pressing `Space`.
   - Connect the TB3 cable to XPS.
   - Turn on the eGPU.
   - Wait for few seconds, and press `Enter` to boot macOS.

## Custom setting the delay between trackpad and keyboard
   To do that you need to edit `Info.plist` in `VoodooI2CHID.kext`:
   - Open the `Info.plist` in the `VoodooI2CHID.kext` with any Text Editor(I use [Atom](https://atom.io/))
   - Finding the `QuietTimeAfterTyping`
   - Changing the `value` you prefer
   ##### I have preset the `value` to `0`

## More Custom Settings
   - Refer to [Commands](https://github.com/the-Quert/macOS-Mojave-XPS9360/tree/master/Commands) for more customization.

## HiDPI
   - Use [one-key-HiDPI](https://github.com/xzhih/one-key-hidpi)

## Fix Blurry Fonts for Non-Retina Displays
   - Refer to [here](https://osxdaily.com/2018/09/26/fix-blurry-thin-fonts-text-macos-mojave/).
##### If booting with `Clover`, blurry font is required to fix.
##### If booting with `OpenCore`, font is clear as Retina, no need to fix.

## Fix AppleID issue on macOS Catalina
- If you encounter the problem with AppleID which cannot login and logout, this problem happened on both
Hackintosh and Macintosh.
- Fix this issue with the follwing commands...
```BASH
        sudo -v
        killall -9 accountsd com.apple.iCloudHelper
        defaults delete MobileMeAccounts
        rm -rf ~/Library/Accounts
        killall -9 accountsd com.apple.iCloudHelper
        sudo reboot
```

## Fix the AirPods choppy/unreliable when connected to macOS
- Open `System Preferences` > `Sound` > `Input`
- Change `Sound Input` from `Airpods` to `Internal Microphone`
- Possible explanation:     
Since `BCM94360CS2`/`DW1560`/`BCM94360NG` are running with `Bluetooth 4.0`, which has too low bandwidth to handle both input/output at a high quality.     
Therefore, changing `Sound Input` to `Internal Microphone` to ensure audio output is working as normal.

## Optional Settings
### CPU Undervolting
#### If having the same CPU as mine, you can do the undervolting settings below.
#### Warning!!! This may cause crash on your device, please be aware of that.
 Enter `BIOS/Boot Sequence` , add new `Boot Option` with `/EFI/CLOVER/tools/DVMT.efi`, then run the following commands...
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

### Upgrading macOS
  - Before upgrading, remember to backup with `Time Machine` through external drive.
  - [Create bootable USB drive](https://github.com/the-Quert/XPS-9360-macOS#create-bootable-usb-installer) with the version of macOS you prefer, and replace files under path `/EFI` in EFI partition with this repo.
  - After booting sucessfully, copy the whole repo to you EFI partition. (The commands to mount EFI partition is provided above.)
  - If you use `DW1560`, follow the [guide](https://github.com/the-Quert/XPS-9360-macOS#post-installation).
  - Refer to [shell script](https://github.com/the-Quert/XPS-9360-macOS#running-shell-script-in-terminal) part, and follow the commands.
  - Follow the guide to set your [CPUFriend](https://github.com/the-Quert/XPS-9360-macOS/blob/master/README.md#cpufriend).
  - Recovery you data and settings from your backup through `Migration Assistant`.

### Migrate bootloader from Clover to OpenCore
  - Copy the OC folder to EFI partition.
  - Clear caches of `Clover`, and compile your own DSDTs by running the followig commands...
  ```
        bash /Volumes/EFI/EFI/OC/trans.sh
        bash /Volumes/EFI/EFI/OC/XPS_OC.sh --compile-dsdt
  ```
  - Enter `BIOS/Boot Sequence` in `BIOS`, add `Boot Entry` with path `/EFI/OC/OpenCore.efi`
  - Reboot and enjoy the flight, and feel free to file issues if encounter any problems.
-----  

## Dev-Notes
   ### External Display Support
   - According to [ioregistryExplorer](https://github.com/vulgo/IORegistryExplorer), `Framebuffer@0 (Connector 0) ` is LVDS (Internal Display).
   - `Framebuffer@1 (Connector 1)`, `Framebuffer@2 (Connector 2)` are pointing to DisplayPort and HDMI respectively.
   - Refer to [gfxutil](https://github.com/acidanthera/gfxutil/releases), path of iGPU is `DevicePath = PciRoot(0x0)/Pci(0x2,0x0)`
   - HDMI is working perfectly, video and audio output are both working flawlessly.
  ```
    ID: 59160000, STOLEN: 34 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00000B0B
    TOTAL STOLEN: 35 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 103 MB, MAX OVERALL: 104 MB (109588480 bytes)
    GPU Name: Intel HD Graphics 620
    Model Name(s): MacBookPro14,2
    Camelia: Disabled, Freq: 1388 Hz, FreqMax: 1388 Hz
    Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3
     [0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000098 - LVDS
     [1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x00000187  - DP
     [2] busId: 0x04, pipe: 10, type: 0x00000800, flags: 0x00000187 - HDMI
        00000800 02000000 98000000
        01050900 00040000 87010000
        02040A00 00080000 87010000
```
  - Known info
  ```
    Digital Audio (HDMI / DVI / DP)
    To enable digital audio it is necessary to set the necessary properties and, usually, patch the connectors.
    To enable audio in general and HDMI in particular use WEG along with AppleALC.kext.
    On 10.10.5 and above, WEG automatically changes the connector-type of DP (00040000) to HDMI (00080000) if no custom patches are used.
    The actual connection may be of any type (HDMI / DVI / DP), but for the digital audio to function the connector-type must explicitly be HDMI.
```       
  When HDMI plugged in, macOS would recognize as DP (busID: 0x05), not HDMI (busID: 0x04).     
  - Table of busID and ports are listed below:

|   DP     |   HDMI   |    DVI    |
| -------- | -------- | --------- |
|   0x02   |   0x00   |    0x01   |
|   0x04   |   0x02   |    0x02   |
|   0x05   |   0x04   |    0x04   |
|   0x06   |   0x06   |    0x06   |
   - `framebuffer-conX-enable`     
      `01000000` -> Enable, `00000000` -> Disable
   - `framebuffer-conX-type`
      `00000800` -> HDMI output, `00000400` -> DP output
   - `framebuffer-conX-index`
      `fffffff` -> Block
   - `framebuffer-unifiedmem`
      `00000080` -> VRAM to 2048M, `000000C0` -> VRAM to 3072M
   - `framebuffer-fbmem`
      `00009000` -> 9M for FHD, `00000003` -> 48M for QHD/UHD
   - All framebuffer values can be insert as `NUMBER` type, except `ig-platform-id`.

### USB Ports Mapping
  - Table of Type and Dev Speed are listed below:

|  USB 2 (XHC)  |  USB 3 (XHC)  | Thunderbolt 3 (TBTU) |        Dev Speed       |
| ------------- | ------------- | -------------------- | ---------------------- |
|      HS01     |      HS01     |                      |    12/480 Mbps         |
|      HS02     |      HS02     |                      |    12/480 Mbps         |
|               |      SS01     |                      |    5 Gbps              |
|               |      SS02     |                      |    5 Gbps              |
|               |               |       UB21           |    5 Gbps              |
|               |               |       UB21           |    5 Gbps              |
   - When USB3 injected, speed would run as 480Mbps/5Gbps.
   - USB2 port: Wireless receiver would run as 12Mbps, other USB2 deivces run as 480Mbps.
   - TB3 devices run as 5Gbps.
   - `HS03` is occupied by `BCM9460CS2`/`DW1560`.
   - `HS05` is occupied by `Intergrated Webcam HD`.

### Boot Arguments Explanation
   - `darkwake=4`     
      The `darkwake` flag has to do with sleep. More information can be found in this [thread](https://www.tonymacx86.com/threads/important-darkwake-0-flag-can-break-auto-sleep-in-10-8-1.69714/#post-447117).
   - `igfxcflbklt=opcode`     
      To work with `WhateverGreen.kext`, fixing BackLight.
   - `brcmfx-country=XX`     
      Change the country code to XX (US, CN, #a, ...) For Broadcom WiFi card.
   - `brcmfx-country=#a`     
      Enables 80MHz wide channels on the 5GHz spectrum. For Broadcom WiFi card.
   - `agdpmod=vit9696`     
      Disable check for `board-id`.
      
### XCPM and HWP
   - Verify working `XCPM` configuration by typing the commands below
   ```BASH
      sysctl machdep.xcpm.mode
      // If returns '1', which means the XCPM is active.
   ```
   - Verify if the `X86PlatformPlugin.kext` is loaded
   ```BASH
      kextstat|grep -y x86plat
   ```

### Shutdown Dialog
   - To activate `shutdown dialog`, it's necessary to  `Rename PBTN to PWRB`.
   - Although `SSDT-PWRB` is added, rename part is also needed in `LPCB`.

## Contributors
#### [ComboJack](https://github.com/hackintosh-stuff/ComboJack)
#### [Acidanthera](https://github.com/acidanthera)
#### [HiDPI](https://github.com/xzhih/one-key-hidpi)
#### [gibMacOS](https://github.com/corpnewt/gibMacOS)
#### [Leo Neo Usfsg](https://www.facebook.com/yuting.lee.leo)
#### Kexts version and developers are mentioned in [kexts_info.txt](https://github.com/the-Quert/macOS-Mojave-XPS9360/blob/master/kexts_info.txt)
