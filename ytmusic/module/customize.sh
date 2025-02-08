# Checking for installation environment
# Abort TWRP installation with error message when user tries to install this module in TWRP

if [ $BOOTMODE = false ]; then
    ui_print "- Installing through TWRP Not supported"
    ui_print "- Install this module via Magisk Manager"
    abort "- Aborting installation !!"
fi

api_level_arch_detect

MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin

PKGNAME="$(grep_prop package "$MODPATH/module.prop")"
APPNAME="YouTube Music"
STOCKAPPVER=$(dumpsys package $PKGNAME | grep versionName | cut -d= -f 2 | sed -n '1p')
RVAPPVER="$(grep_prop version "$MODPATH/module.prop")"
URL="https://www.apkmirror.com/apk/google-inc/youtube-music/youtube-music-$(echo -n "$RVAPPVER" | tr "." "-")-release/"

# Check if ksu_susfs exists
if [ -f "/data/adb/ksu/bin/ksu_susfs" ]; then
    ui_print "- KernelSU environment detected (Susfs found)"
    KERNELSU=true
else
    ui_print "- Susfs not detected"
    KERNELSU=false
fi

# Install base APK if YouTube Music is not installed
if [ ! -d "/proc/1/root/data/data/$PKGNAME" ]; then
    ui_print "- $APPNAME app is not installed"
    ui_print "- Installing $APPNAME from base APK"
    
    pm install --force-sdk --full -g -i com.android.vending -r -d $MODPATH/base.apk
    
    if [ $? -eq 0 ]; then
        ui_print "- Installation of base APK successful"
        rm -rf $MODPATH/base.apk
    else
        ui_print "- Installation of base APK failed"
        am start -a android.intent.action.VIEW -d "$URL" &>/dev/null
        abort "- Aborting installation !!"
    fi
fi

# Check for process monitor tool in non-Sus environment
if [ "$KERNELSU" = false ]; then
    [ ! -d "/data/adb/modules/magisk_proc_monitor" ] && {
        MURL=http://github.com/HuskyDG/magisk_proc_monitor
        ui_print "- Process monitor tool is not installed"
        ui_print "  Please install it from $MURL"
        am start -a android.intent.action.VIEW -d "$MURL" &>/dev/null
    }
fi

# Handle version mismatch
if [ "$STOCKAPPVER" != "$RVAPPVER" ]; then
    ui_print "- Installed $APPNAME version = $STOCKAPPVER"
    ui_print "- $APPNAME RevancedExtended version = $RVAPPVER"
    ui_print "- App Version Mismatch !!"
    ui_print "- Attempting to install $APPNAME from base APK"
    
    pm install --force-sdk --full -g -i com.android.vending -r -d $MODPATH/base.apk
    
    if [ $? -eq 0 ]; then
        ui_print "- Installation of base APK successful"
        rm -rf $MODPATH/base.apk
    else
        ui_print "- Installation of base APK failed"
        am start -a android.intent.action.VIEW -d "$URL" &>/dev/null
        abort "- Aborting installation !!"
    fi
fi

# Handle split APK installation
stock_path=$(pm path $PKGNAME --user 0 2>&1 </dev/null | sed "s/package://g")
if [ "$(echo "$stock_path" | wc -l)" -gt 1 ]; then
    ui_print "- Detected split APK installation of $APPNAME"
    ui_print "- Attempting to install $APPNAME from base APK"
    pm install --force-sdk --full -g -i com.android.vending -r -d $MODPATH/base.apk
    if [ $? -eq 0 ]; then
        ui_print "- Installation of base APK successful"
        rm -rf $MODPATH/base.apk
    else
        ui_print "- Installation of base APK failed"
        am start -a android.intent.action.VIEW -d "$URL" &>/dev/null
        abort "- Aborting installation !!"
    fi
fi

# Install sqlite3 plug-in for detach
ui_print "- Install sqlite3 plug-in for detach"
mkdir "$MODPATH/bin"
unzip -oj "$MODPATH/sqlite3.zip" "$ABI/sqlite3" -d "$MODPATH/bin" &>/dev/null || abort "! Unzip failed"
chmod 755 "$MODPATH/bin/sqlite3"
rm -rf "$MODPATH/sqlite3.zip"


# Disable battery optimization for YouTube Music ReVancedExtended
sleep 1
ui_print "- Disable Battery Optimization for YouTube Music ReVancedExtended"
dumpsys deviceidle whitelist +$PKGNAME > /dev/null 2>&1

ui_print "- Install Successful !!"