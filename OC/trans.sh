{
	sudo rm -rf /Library/PreferencePanes/Clover.prefPane
	rm -rf "/etc/rc.clover.lib"
	rm -rf "/etc/rc.boot.d/10.save_and_rotate_boot_log.local"
	rm -rf "/etc/rc.boot.d/20.mount_ESP.local"
	rm -rf "/etc/rc.boot.d/70.disable_sleep_proxy_client.local.disabled"
	rm -rf "/etc/rc.boot.d/80.save_nvram_plist.local"
	rm -rf "/etc/rc.shutdown.local"
	rm -rf "/etc/rc.boot.d"
	rm -rf "/etc/rc.shutdown.d"
	launchctl unload '/Library/LaunchDaemons/com.slice.CloverDaemonNew.plist'
	rm -rf '/Library/LaunchDaemons/com.slice.CloverDaemonNew.plist'
	rm -rf '/Library/Application Support/Clover/CloverDaemonNew'
	rm -rf '/Library/Application Support/Clover/CloverLogOut'
	rm -rf '/Library/Application Support/Clover/CloverWrapper.sh'
}