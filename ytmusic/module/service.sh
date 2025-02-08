#!/system/bin/sh

MODDIR=${0%/*}
MODNAME="${MODDIR##*/}"
SUSFS_BIN="/data/adb/ksu/bin/ksu_susfs"

# Wait for boot completion
while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do
    sleep 5
done

# Wait for device to decrypt (if encrypted)
until [ -d "/sdcard/Android" ]; do
    sleep 2
done

sh "$MODDIR/detachyt.sh"
# Check if ksu_susfs exists (KernelSU environment)
if [ -f "$SUSFS_BIN" ]; then
    echo "- KernelSU environment detected (susfs found)"
    
    base_path="${MODDIR}/revanced.apk"
    stock_path="$(pm path com.google.android.apps.youtube.music | sed -n '/base/s/package://p')"
    
    if [ ! -f "$base_path" ]; then
        exit 1
    fi
    
    am force-stop "com.google.android.apps.youtube.music"
    chcon u:object_r:apk_data_file:s0 "$base_path"
    ${SUSFS_BIN} add_sus_kstat "$stock_path"
    [ ! -z "$stock_path" ] && mount -o bind "$base_path" "$stock_path"
    ${SUSFS_BIN} update_sus_kstat "$stock_path"
    ${SUSFS_BIN} add_sus_mount "$stock_path"
    am force-stop com.google.android.apps.youtube.music
else
    echo "- Non-Sus environment detected"
    
    MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin
    TMPFILE="$MAGISKTMP/.magisk/modules/$MODNAME/module.prop"
    
    . "$MODDIR/utils.sh"
    [ -e "$MODDIR/loaded" ] || { check_version && . "$MODDIR/mount.sh"; } || exit 0
    
    W=$(sed -E 's/^description=(\[.*][[:space:]]*)?/description=[ 😅 File is mounted globally because Dynamic mount is not working. ] /g' "$MODDIR/module.prop")
    echo -n "$W" >"$TMPFILE"
fi