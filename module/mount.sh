. "$MODDIR/utils.sh"
PACKAGE_NAME="$(grep_prop package "$MODDIR/module.prop")"
base_path="$MODDIR/revanced.apk"
stock_path=$(pm path com.google.android.youtube --user 0 2>&1 </dev/null | sed "s/package://g" )
if [ -z "$stock_path" ]; then exit 0; fi
chcon u:object_r:magisk_file:s0 "$base_path"
chmod 0755 "$base_path"
mount -o bind "$base_path" "$stock_path"