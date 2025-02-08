MODDIR="${0%/*}"
MODNAME="${MODDIR##*/}"
MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs


if [ -f "$SUSFS_BIN" ]; then
stock_path="$(pm path com.google.android.youtube | sed -n '/base/s/package://p')"

[ ! -z "$stock_path" ] && umount -l "$stock_path"

grep com.google.android.youtube /proc/mounts | cut -d " " -f 2 | sed "s/apk.*/apk/" | xargs -r umount -l

else

PROPFILE="$MAGISKTMP/.magisk/modules/$MODNAME/module.prop"
TMPFILE="$MAGISKTMP/revanced.prop"
cp -af "$MODDIR/module.prop" "$TMPFILE"

sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ Module is not working. ] /g' "$TMPFILE"
flock "$MODDIR/module.prop"

mount --bind "$TMPFILE" "$PROPFILE"

rm -rf "$MODDIR/loaded"
exit 0
fi
