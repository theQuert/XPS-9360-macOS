{
        sudo -v
        killall -9 accountsd com.apple.iCloudHelper
        defaults delete MobileMeAccounts
        rm -rf ~/Library/Accounts
        killall -9 accountsd com.apple.iCloudHelper
        sudo reboot
        }
