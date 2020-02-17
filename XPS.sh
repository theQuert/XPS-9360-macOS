#!/bin/sh

# Bold / Non-bold
BOLD="\033[1m"
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[1;34m"
#echo -e "\033[0;32mCOLOR_GREEN\t\033[1;32mCOLOR_LIGHT_GREEN"
OFF="\033[m"

# Repository location
REPO=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
GIT_DIR="${REPO}"

git_update()
{
	cd ${REPO}
	echo "${GREEN}[GIT]${OFF}: Updating local data to latest version"

	echo "${BLUE}[GIT]${OFF}: Updating to latest XPS-9360-Hackintosh git master"
	echo "${BLUE}[GIT]${OFF}: Git clone newest repository to current path"
	git pull
}

compile_dsdt()
{
	echo "${GREEN}[DSDT]${OFF}: Compiling  DSDT / SSDT hotpatches in ./DSDT"
	cd "${REPO}"

	for f in ./DSDT/*.dsl
	do
		echo "${BLUE}$(basename $f)${OFF}: Compiling to ./CLOVER/ACPI/patched"
		./tools/iasl -vr -w1 -ve -p ./CLOVER/ACPI/patched/$(basename -s .dsl $f).aml $f
	done
}

combo_jack()
{
	echo "${GREEN}[ComboJack]${OFF}: Installing ComboJack for ${BOLD}ALC256${OFF}"
	./ComboJack/install.sh
}

enable_trim()
{
	echo "${GREEN}[TRIM]${OFF}: Enabling ${BOLD}TRIM${OFF} support for 3rd party SSD"
	sudo trimforce enable
}

enable_3rdparty()
{
	echo "${GREEN}[3rd Party]${OFF}: Enabling ${BOLD}3rd Party${OFF} application support"
	sudo spctl --master-disable
}

rebuild_cache()
{
	echo "${GREEN}[Rebuild cache]${OFF}: Rebuild cache"
	sudo chmod -R 755 /Library/Extensions
	sudo chown -R root:wheel /Library/Extensions
	sudo kextcache -i /
}
better_sleep()
{
	echo "${GREEN}[Sleep fixing]${OFF}: For Better Sleep"
	sudo pmset -a hibernatemode 0
	sudo pmset -a autopoweroff 0
	sudo pmset -a standby 0
	sudo rm /private/var/vm/sleepimage
	sudo touch /private/var/vm/sleepimage
	sudo chflags uchg /private/var/vm/sleepimage
}
pin_custom()
{
	echo "${GREEN}[Pin custom]${OFF}: Disable 4-Digit Pin Required on macOS"
	pwpolicy -clearaccountpolicies
	passwd
}

RETVAL=1

case "$1" in
	--update)
		git_update
		RETVAL=0
		;;
	--compile-dsdt)
		compile_dsdt
		RETVAL=0
		;;
	--combo-jack)
		combo_jack
		RETVAL=0
		;;
	--enable-trim)
		enable_trim
		RETVAL=0
		;;
	--enable-3rdparty)
		enable_3rdparty
		RETVAL=0
		;;
	--rebuild-cache)
		rebuild_cache
		RETVAL=0
		;;
	--better-sleep)
		better_sleep
		RETVAL=0
		;;
	--pin-custom)
		pin_custom
		RETVAL=0
		;;
	*)
		echo "${BOLD}macOS on XPS 13 9360${OFF} - Catalina 10.15.3 (19D76)"
		echo "https://github.com/the-Quert/XPS-9360-macOS"
		echo
		echo "\t${BOLD}--update${OFF}: Update to latest git version (including externals)"
		echo "\t${BOLD}--compile-dsdt${OFF}: Compile DSDT files to ./DSDT/compiled"
		echo "\t${BOLD}--combo-jack${OFF}: Install ComboJack user daemon (Headset / Headphone detection)"
		echo "\t${BOLD}--enable-trim${OFF}: Enable trim support for 3rd party SSD"
		echo "\t${BOLD}--enable-3rdparty${OFF}: Enable 3rd party application support (run app from anywhere)"
		echo "\t${BOLD}--rebuild-cache${OFF}: Rebuild cache"
		echo "\t${BOLD}--better-sleep${OFF}: For better sleep"
		echo "\t${BOLD}--pin-custom${OFF}: Disable 4-Digit Pin Required on macOS"
		echo
		echo "Credits:"
		echo "${BLUE}ComboJack${OFF}: https://github.com/hackintosh-stuff/ComboJack"
		echo "${BLUE}CPUFriend${OFF}: https://github.com/acidanthera/CPUFriend"
		echo "${BLUE}HiDPI${OFF}: https://github.com/xzhih/one-key-hidpi"
		echo "${BLUE}OpenCore-Configurator${OFF}: https://github.com/notiflux/OpenCore-Configurator"
		echo "${BLUE}daliansky${OFF}: https://github.com/daliansky"
		echo "${BLUE}Leo Neo Usfsg${OFF}: https://www.facebook.com/yuting.lee.leo"
		echo
		;;
esac

exit $RETVAL
