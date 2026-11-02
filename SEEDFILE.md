# SEEDFILE - manaus degoogle project

Durable context for this repo. Read this before changing anything. Every fact
below names its source and is marked VERIFIED (checked against the linked
source on Nov 2, 2026) or UNVERIFIED (still needs a check before you rely on
it).

## Project goals

- Lightweight, degoogled, no tracking daily-driver ROM for the owner's
  Motorola edge 40 neo.
- The phone is his DAILY DRIVER. This repo is groundwork only: research,
  setup docs, configs, patches, scripts.
- DO NOT write or run device-facing flashing/unlock instructions as an
  executable runbook until the owner confirms he has a spare phone.
  Documenting processes as reference is fine.

## Device identity

- Marketing name: motorola edge 40 neo. VERIFIED (LineageOS wiki).
- Codename: manaus. VERIFIED (LineageOS wiki, kernel-mtk commits).
- Model numbers: XT2307-1, XT2307-2, XT2307-3 are the LineageOS-supported
  variants. VERIFIED (LineageOS wiki).
- Owner's exact variant: UNVERIFIED - most likely RETIN (Retail India)
  since he is in India. Check Settings > About phone > Model number, and the
  software channel in Settings > About phone > Build number before flashing
  anything.

## Hardware platform

- SoC: MediaTek Dimensity 7030 (MT6879, 6 nm). VERIFIED (LineageOS wiki,
  GSMArena).
- CPU: octa-core, 2x Cortex-A78 @ 2.5 GHz + 6x Cortex-A55 @ 2.0 GHz. GPU:
  ARM Mali-G610 MC3. VERIFIED (LineageOS wiki).
- RAM: 8/12 GB LPDDR5X. Storage: 128/256 GB uMCP. VERIFIED (LineageOS wiki).
- Display: 6.55" P-OLED 1080x2400, up to 144 Hz. Battery: 5000 mAh.
  VERIFIED (LineageOS wiki).

## Software baseline

- Shipped with Android 13. VERIFIED (GSMArena).
- Official Motorola updates reached Android 15: RETIN channel firmware
  V1TMS35H.3-45-3-2-7 (Android 15) is the newest mirrored build seen;
  U1TMS34.107-34-9-x was Android 14. VERIFIED (lolinet mirror listing,
  Nov 2, 2026).
- Kernel: 5.10. VERIFIED (LineageOS wiki).
- Project Treble: device launched with Android 13, so Treble support is
  mandatory and community members confirm GSIs boot on it. VERIFIED at the
  community-report level (XDA/Reddit/DEV guides linked below), not yet
  verified on the owner's own unit.
- Partition layout: fastboot flashes vbmeta.img, boot.img and
  vendor_boot.img (recovery lives in vendor_boot); the ROM zip is sideloaded
  in recovery. This is the standard dynamic-partitions flow, but the full
  partition map (super contents, A/B slots) is UNVERIFIED - confirm from the
  LineageOS install guide and stock firmware before any flash.

## ROM options (ranked for this project)

1. LineageOS for microG - PRIMARY CANDIDATE.
   Degoogled out of the box (microG replaces Google Play Services), and it
   still builds for manaus: lineage-23.2-20260917-microG-manaus.zip
   (LineageOS 23.2 = Android 16, built Sept 17, 2026).
   VERIFIED: https://download.lineage.microg.org/manaus/
2. Official LineageOS builds - DISCONTINUED for manaus.
   The device was officially supported at 23.2 but is now unmaintained
   (wiki warning as of Nov 2, 2026). Private builds are possible via the
   official build guide, and could restart official support.
   VERIFIED: https://wiki.lineageos.org/devices/manaus/
   Build guide: https://wiki.lineageos.org/devices/manaus/build/
3. GSI images (LineageOS "light"/"td" GSIs by Andy Yan, crDroid GSI) +
   manual microG setup - fallback. Community reports confirm GSIs work on
   this phone. Specific GSI release and patch level: UNVERIFIED - pick at
   flash time from https://sourceforge.net/projects/andyyan-gsi/files/
   and the device-specific reports below.

## Bootloader unlock (reference only - do not execute yet)

- Official Motorola process: enable OEM unlocking in Developer options
  (newer Motorolas may need the device online up to 7 days before the
  toggle works), get the unlock string via fastboot, request the unlock
  code from Motorola's portal, then fastboot oem unlock. VERIFIED as the
  official flow (LineageOS install guide for manaus, Motorola support
  pages, XDA device guide).
- Portal: https://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-a
  (bot-gated to scripts; open in a real browser).
- Consequences: warranty flag, full data wipe, and on this device family a
  possible impact on Widevine L1 / camera processing - UNVERIFIED for
  manaus specifically, research before committing.
- Device guide with owner reports: https://xdaforums.com/t/guide-motorola-edge-40-neo-bootloader-unlock-root-safetynet-pass.4701474/

## Key links

- LineageOS device page: https://wiki.lineageos.org/devices/manaus/
- LineageOS install guide: https://wiki.lineageos.org/devices/manaus/install/
- LineageOS for microG builds: https://download.lineage.microg.org/manaus/
- microG project: https://microg.org/
- Motorola kernel source (contains manaus commits; Motorola answers source
  requests via issues): https://github.com/MotorolaMobilityLLC/kernel-mtk
- Stock firmware mirror (RETIN = India): https://mirrors.lolinet.com/firmware/lenomola/2023/manaus/official/RETIN/
- XDA: GSI install discussion: https://xdaforums.com/t/how-to-install-a-gsi-rom.4615889/
- Reddit: owner GSI install report: https://www.reddit.com/r/motorola/comments/1fs1fvq/edge_40_neo_gsirom_install_instructions/
- DEV.to: unlock + GSI walkthrough for this device: https://dev.to/gamedev90/unlocking-android-bootloader-and-flashing-gsi-a-complete-guide-for-motorola-edge-40-neo-595m

## Boot modes (VERIFIED, LineageOS wiki)

- Recovery: power off, hold Volume Down + Power, select "Recovery mode".
- Fastboot/Bootloader: power off, hold Volume Down + Power until
  "FastBoot Mode" appears.

## Known quirks

- LineageOS wiki lists "Device Integrity" (Play Integrity) as a known
  quirk area for manaus. Banking apps may need extra work (root +
  Play Integrity Fix territory). UNVERIFIED on current builds.
- Always keep a copy of the matching RETIN stock firmware before any
  flash, so the phone can be restored with Motorola's recovery tools.

## Open questions for the owner

1. Exact model variant and current build number (Settings > About phone).
2. Spare phone available? (Gate for any real flashing.)
3. Does he need banking/UPI apps to work? (Drives the Play Integrity plan.)
