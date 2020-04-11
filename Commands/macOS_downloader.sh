#!/bin/bash

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The {censored} You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details. */

# One more contribution to open source world.

# Note: try to reduce lines and add more features
#       you will be add in contribute area.


# Global functions
print() { printf -- "$1\n"; }
log() { printf -- "\033[37m LOG: $1 \033[0m\n"; }
success() { printf -- "\033[32m SUCCESS: $1 \033[0m\n"; }
warning() { printf -- "\033[33m WARNING: $1 \033[0m\n"; }
error() { printf -- "\033[31m ERROR: $1 \033[0m\n"; }
heading() { printf -- "   \033[1;30;42m $1 \033[0m\n\n"; }
newUiPage() {
  clear
  echo "---------------------------------------------------"
  echo "-       macOS Legit Copy Downloader        -"
  echo "- If want to create installer, be sure to  -"
  echo "- erase your USB drive, and rename it to   -"
  echo "- named <Installer>                        -"
  echo "---------------------------------------------------"
  echo " Contributor: ricoc90, the-Quert"
  echo " "
  echo " "
}


# Global Variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
tmpDir="$DIR"
srcDir="$DIR/macOSsrc"

# Prgram functions
downloadAndParseCatalog(){

    # Download catalog file from apple server
    #-------------------------------
    print "\nLoading macOS catalog from swscan.apple.com..."
    if ! curl --fail -s -f -o "$tmpDir/catalog.gz" "$1"; then error "Failed to download catalog" && exit; fi
    gunzip -k "$tmpDir/catalog.gz"
    rm "$tmpDir/catalog.gz"


    # Parse catalog file into arrays
    #-------------------------------
    versionsArray=($(getListOfVersions))

    appleDiagnosticsArray=($(findLinkInCatalog AppleDiagnostics.dmg "$tmpDir/catalog"))
    appleDiagnosticsChunklistArray=($(findLinkInCatalog AppleDiagnostics.chunklist "$tmpDir/catalog"))
    baseSystemArray=($(findLinkInCatalog BaseSystem.dmg "$tmpDir/catalog"))
    baseSystemChunklistArray=($(findLinkInCatalog BaseSystem.chunklist "$tmpDir/catalog"))
    installInfoArray=($(findLinkInCatalog InstallInfo.plist "$tmpDir/catalog"))
    installESDArray=($(findLinkInCatalog InstallESDDmg.pkg "$tmpDir/catalog"))

    rm "$tmpDir/catalog"

}

findLinkInCatalog(){
    array=($(awk '/'$1'</{print $1}' "$2"))
    let index=0
    for element in "${array[@]}"; do
        array[$index]="${element:8:${#element}-17}"
        let index=index+1
    done
    echo ${array[@]}
}

getListOfVersions(){
    versionInfoArray=($(findLinkInCatalog InstallInfo.plist "$tmpDir/catalog"))
    let index=0
    for element in "${versionInfoArray[@]}"; do
        infoline=$(curl -s -f $element | tail -5)
        versionInfo[$index]="$(echo $infoline | awk -v FS="(string>|</string)" '{print $2}')"
        let index++
    done
    echo ${versionInfo[@]}
}




checkOSAvaibility() {
    if curl --output /dev/null --silent --head --fail "https://swscan.apple.com/content/catalogs/others/index-$1seed-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"; then echo "$1"; else echo "10.14"; fi
}





downloadOS(){
    # Print User Interface
    newUiPage
    LATEST_VERSION=$(checkOSAvaibility "10.15")

    # User input for selecting release type
    PS3=""$'\n(You can also able to download macOS 10.15 when it will available)\n\n'"Which release you want? "
    select RELEASETYPE in "Developer Release" "Beta Release" "Public Release"; do
        case $RELEASETYPE in
            Developer* ) CATALOGTYPE="-${LATEST_VERSION}seed"; break;;
            Beta* ) CATALOGTYPE="-${LATEST_VERSION}beta"; break;;
            Public* ) break;;
        esac
    done


    downloadAndParseCatalog "https://swscan.apple.com/content/catalogs/others/index${CATALOGTYPE}-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"


    newUiPage
    # User input for selecting macOS versions
    PS3=""$'\n'"Select macOS version : "
    select MACVERSION in "${versionsArray[@]}"; do
        if [[ $REPLY -le ${#versionsArray[@]} && $REPLY -gt 0 ]]
            then

                # Dont break sequence (It's sequenced with $fileNames[@])
                links=(${appleDiagnosticsArray[$[$REPLY - 1]]} ${appleDiagnosticsChunklistArray[$[$REPLY - 1]]} ${baseSystemArray[$[$REPLY - 1]]} ${baseSystemChunklistArray[$[$REPLY - 1]]} ${installInfoArray[$[$REPLY - 1]]} ${installESDArray[$[$REPLY - 1]]})
                fileNames=("AppleDiagnostics.dmg" "AppleDiagnostics.chunklist" "BaseSystem.dmg" "BaseSystem.chunklist" "InstallInfo.plist" "InstallESDDmg.pkg")

                # Ask user to download macOS or only print links
                while true; do read -p ""$'\n'"You wanna download macOS ? [y/n] " yn
                    print ""
                    if [[ $yn == y ]]; then

                            # make source directory
                            if [ ! -d "$srcDir" ]; then mkdir "$srcDir"; fi

                            # Download files into $srcDir from $links[@]
                            for i in {0..5}; do
                                curl -f -o "$srcDir/${fileNames[$i]}" "${links[$i]}"
                            done && break;

                        elif [[ $yn == n ]]; then
                            for link in "${links[@]}"; do print $link; done && break; #&& exit;
                    fi
                done

                break
            else error "Invalid choice."
        fi
    done
}



createinstallapp(){
    #---------------------------------------------------------------------------
    #  Create Install Media
    #---------------------------------------------------------------------------

    # Taking ownership of downloaded files
    #-------------------------------------------------
    chmod a+x "$srcDir/BaseSystem.dmg"
    chmod a+x "$srcDir/BaseSystem.chunklist"
    chmod a+x "$srcDir/InstallInfo.plist"
    chmod a+x "$srcDir/InstallESDDmg.pkg"
    chmod a+x "$srcDir/AppleDiagnostics.dmg"
    chmod a+x "$srcDir/AppleDiagnostics.chunklist"


    # Mount 'BaseSystem.dmg'
    #-------------------------
    $(hdiutil attach "$srcDir/BaseSystem.dmg" 2>&1 >/dev/null)

    print "\n\nMake sure \"macOS Base System\" volume is mounted\n"
    read -p "Press enter to continue..."


    # Pull 'Install macOS XXXX.app' from 'BaseSystem.dmg'
    #-----------------------------------------------------
    FOLDERS=(/Volumes/*)
    for folder in "${FOLDERS[@]}"; do
        [[ -d "$folder" && "$folder" =~ "macOS Base System" ]] && basePath="$folder"
    done



    for file in "$basePath/"*; do # Find XXXX.app in mounted volume
        if [[ $file == *.app ]]; then
            let index=${#name_array[@]}
            name_array[$index]="${file##*/}"
        fi
    done
    installAppName=${name_array[0]}



    newUiPage
    print "Copying $installAppName to out folder..."
    cp -R "/Volumes/macOS Base System/$installAppName" "$DIR/"


    # UnMount 'BaseSystem.dmg'
    #-------------------------
    $(hdiutil detach /Volumes/macOS\ Base\ System 2>&1 >/dev/null)

    print "Copying Files to SharedSupport folder...\n"

    # Create SharedSupport folder inside 'Install macOS XXXX.app/Contents'
    #----------------------------------------------------------------------
    SharedSupportDir="$DIR/${installAppName}/Contents/SharedSupport"
    if [ ! -d "$SharedSupportDir" ]; then mkdir "$SharedSupportDir"; fi


    # Copy All contents of src folder to 'Install macOS XXXX.app/Contents/SharedSupport'
    #----------------------------------------------------------------------
    # cp -R $srcDir/* $DIR/Install\ macOS\ Mojave\ Beta.app/Contents/SharedSupport

    cp -R "$srcDir/BaseSystem.dmg" "$SharedSupportDir"
    cp -R "$srcDir/BaseSystem.chunklist" "$SharedSupportDir"
    cp -R "$srcDir/InstallInfo.plist" "$SharedSupportDir"
    cp -R "$srcDir/AppleDiagnostics.dmg" "$SharedSupportDir"
    cp -R "$srcDir/AppleDiagnostics.chunklist" "$SharedSupportDir"

    # This file will be copied with InstallESD.dmg name
    cp -R "$srcDir/InstallESDDmg.pkg" "$SharedSupportDir/InstallESD.dmg"


    # Replace <string>InstallESDDmg.pkg</string> to <string>InstallESD.dmg</string> in 'src/InstallInfo.plist'
    #----------------------------------------------------------------------------------------------------------
    sed -i "" 's/<string>InstallESDDmg.pkg<\/string>/<string>InstallESD.dmg<\/string>/g' "$SharedSupportDir/InstallInfo.plist"



    # Remove these lines from 'src/InstallInfo.plist'
    #------------------------------------------------
    #		<key>chunklistURL</key>
    #		<string>InstallESDDmg.chunklist</string>
    #		<key>chunklistid</key>
    #		<string>com.apple.chunklist.InstallESDDmg</string>
    sed -i "" '30,33d' "$SharedSupportDir/InstallInfo.plist"


    # Replace <string>com.apple.pkg.InstallESDDmg</string> to <string>com.apple.dmg.InstallESD</string> in 'src/InstallInfo.plist'
    #----------------------------------------------------------------------------------------------------------
    sed -i "" 's/<string>com.apple.pkg.InstallESDDmg<\/string>/<string>com.apple.dmg.InstallESD<\/string>/g' "$SharedSupportDir/InstallInfo.plist"


    # Replace InstallESDDmg.pkg to InstallESD.dmg in 'src/InstallInfo.plist'
    #----------------------------------------------------------------------------------------------------------
    sed -i "" 's/InstallESDDmg.pkg/InstallESD.dmg/g' "$SharedSupportDir/InstallInfo.plist"
}



burndmg()
{
    sudo ./Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/Installer
}



newUiPage
# User input for selecting release type
PS3=""$'\n'"What you want to do? "
select RELEASETYPE in "Download macOS" "Make bootable Media" "Burn the target <Install macOS Catalina.app> to USB drive"; do
    case $RELEASETYPE in
        Download* ) downloadOS; break;;
        Make* ) createinstallapp; break;;
        Burn* ) burndmg; break;;
    esac
done


exit
