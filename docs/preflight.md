# Preflight: reading the actual phone (read-only)

`scripts/preflight.sh` answers the device questions in
[SEEDFILE.md](../SEEDFILE.md) that web sources cannot: which exact variant
this unit is, what firmware channel it is on, and whether the Treble /
dynamic-partitions facts hold on the real hardware.

It only runs `adb get-state`, `adb shell getprop`, `adb shell uname` and
similar read commands. It cannot reboot, unlock, wipe, or flash anything.

## One-time setup on the phone

1. Settings > About phone > tap "Build number" 7 times to unlock
   Developer options.
2. Settings > System > Developer options > enable "USB debugging".
3. Plug the phone into the computer, run `adb devices`, and accept the
   authorization prompt on the phone.

Enabling Developer options and USB debugging changes nothing persistent
about the software and does not trip the bootloader or warranty flags.

## Run

```sh
sh scripts/preflight.sh
```

## Reading the output

- `OK` - the phone matches what the SEEDFILE expects.
- `CHECK` - the phone disagrees with the expectation. Update the SEEDFILE
  entry with the actual value before trusting any plan that depends on it.
- `??` - the property was unreadable (normal for a few vendor-specific
  keys on some builds).

The report maps to the SEEDFILE like this:

| Preflight line          | SEEDFILE item it settles                          |
| ----------------------- | ------------------------------------------------- |
| model                   | Open question 1: exact variant (XT2307-1/-2/-3)   |
| build fingerprint/id    | Open question 1: software channel (expect RETIN)  |
| android release, patch  | Software baseline: which stock build he is on     |
| first api level = 33    | Treble mandatory (shipped with Android 13)        |
| treble enabled          | GSI fallback option stays on the table            |
| dynamic partitions, a/b | Partition layout (currently marked UNVERIFIED)    |
| oem unlock allowed      | Whether Developer options allows unlocking yet    |
| vbmeta device state     | Whether the bootloader is still locked            |

## Safety notes

- Keep USB debugging off again when done if the phone leaves your desk.
- The script does not need root and does not contact Motorola or Google.
