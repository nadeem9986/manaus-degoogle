# manaus-degoogle

Groundwork for a lightweight, degoogled, no-tracking ROM setup for the
motorola edge 40 neo (codename: manaus).

Everything starts at [SEEDFILE.md](SEEDFILE.md) - device facts (verified
against sources, with anything unverified marked), ROM options, unlock
reference, and the project rules.

Status: research/groundwork only. No flashing steps to execute until the
owner has a spare phone.

## What's here

- [SEEDFILE.md](SEEDFILE.md) - verified device facts, ROM options, unlock
  reference, project rules.
- [scripts/preflight.sh](scripts/preflight.sh) - read-only adb script that
  reads the actual phone's variant, firmware channel and Treble/partition
  facts. See [docs/preflight.md](docs/preflight.md). Nothing else touches
  the device.
