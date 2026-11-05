#!/bin/sh
# preflight.sh - read-only fact gatherer for the manaus degoogle project.
#
# Runs ONLY adb read commands (get-state, shell getprop, uname, settings
# get). It never reboots, unlocks, wipes, flashes, or writes to the phone.
# Its job is to close the UNVERIFIED device facts in SEEDFILE.md using the
# owner's actual unit.
#
# Usage:  sh scripts/preflight.sh
# Needs:  adb on PATH (Android platform-tools), USB debugging enabled on
#         the phone, and the phone's authorization prompt accepted.

set -u

fail() { echo "ERROR: $*" >&2; exit 1; }

command -v adb >/dev/null 2>&1 || fail "adb not found on PATH. Install Android platform-tools first."

state=$(adb get-state 2>/dev/null || echo "unreachable")
[ "$state" = "device" ] || fail "phone not authorized over adb (state: $state). Accept the USB-debugging prompt on the phone."

prop() {
    # $1 = property name; prints the value, or UNKNOWN when empty/missing
    v=$(adb shell "getprop $1" 2>/dev/null | tr -d '\r')
    if [ -n "$v" ]; then printf '%s' "$v"; else printf 'UNKNOWN'; fi
}

check() {
    # $1 label, $2 property, $3 expected value, $4 optional note
    label=$1; name=$2; expected=$3; note=${4:-}
    actual=$(prop "$name")
    if [ "$actual" = "$expected" ]; then
        verdict=OK
    elif [ "$actual" = "UNKNOWN" ]; then
        verdict="??"
    else
        verdict=CHECK
    fi
    printf '%-26s actual: %-34s expected: %-12s %s\n' "$label" "$actual" "$expected" "$verdict"
    if [ -n "$note" ]; then printf '%-26s %s\n' "" "note: $note"; fi
}

check_prefix() {
    # $1 label, $2 property, $3 glob the value must match, $4 shown expectation
    label=$1; name=$2; glob=$3; shown=$4
    actual=$(prop "$name")
    case "$actual" in
        $glob) verdict=OK ;;
        UNKNOWN) verdict="??" ;;
        *) verdict=CHECK ;;
    esac
    printf '%-26s actual: %-34s expected: %-12s %s\n' "$label" "$actual" "$shown" "$verdict"
}

report() {
    # $1 label, $2 value (free-form, no expectation)
    printf '%-26s %s\n' "$1" "$2"
}

echo "manaus degoogle - preflight report (read-only)"
echo "date: $(date -u '+%Y-%m-%d %H:%M UTC')"
echo

echo "-- identity --"
check "device codename"        ro.product.device            manaus
check_prefix "model"           ro.product.system.model      'XT2307*'    "XT2307-*"
report "build fingerprint" "$(prop ro.build.fingerprint)"
report "build display id" "$(prop ro.build.display.id)"
check_prefix "android release" ro.build.version.release     '1[345]'     "13, 14 or 15"
report "security patch" "$(prop ro.build.version.security_patch)"

echo
echo "-- ROM readiness --"
check "first api level"        ro.product.first_api_level   33          "33 = shipped with Android 13, so Treble is mandatory"
check "treble enabled"         ro.treble.enabled            true        "required before any GSI is even an option"
report "vndk version" "$(prop ro.vndk.version)"
check "dynamic partitions"     ro.boot.dynamic_partitions   true        "expected on this platform; affects how images flash"
report "a/b seamless updates" "$(prop ro.build.ab_update)"
check "cpu abi"                ro.product.cpu.abi           arm64-v8a
report "kernel version" "$(adb shell uname -r 2>/dev/null | tr -d '\r')"
check_prefix "kernel property" ro.kernel.version            '5.10*'      "5.10.x"

echo
echo "-- bootloader state (read-only) --"
report "oem unlock allowed" "$(prop sys.oem_unlock_allowed)"
report "verified boot state" "$(prop ro.boot.verifiedbootstate)"
report "vbmeta device state" "$(prop ro.boot.vbmeta.device_state)"

echo
echo "Share this output when updating the open questions in SEEDFILE.md."
echo "Nothing on the phone was modified."
