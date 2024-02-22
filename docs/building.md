# Building the VM 

The FujiNet VM is built programmatically using [Packer](https://packer.io).  All aspects of the VM's setup & configuration are done using scripts & configuration in order to make the process fully repeatable.  When new versions or improvements are available for any of the core tooling, services or emulators in the VM a new version can quickly be created with a simple command.  

## Running Packer Build

A shell script called `packer_build.sh` has been created that makes running the appropriate Packer command simple: 

```shell
./packer_build.sh [-v version] [-l] [-c] [-h]

  -v <version>      Provide a version for the VM build (default: 'test')
  -l                If set build WILL NOT be uploaded to MEGA (local only)
  -c                Just copy the OVA to MEGA
  -h                Display this help
```

When the Packer build completes, two files are produced: 

- `packer.out` - The raw log output from the Packer build that can be useful for troubleshooting installation & configuration steps
- `output/fujinet-debian12-vbox.ova` - The actual compressed OVA file containing the VM as a packaged appliance

## Upload to MEGA

Built versions of the OVA file are typically uploaded & shared from [MEGA.nz](https://mega.nz).  The `packer_build.sh` script will attempt to upload the OVA file to MEGA automatically but this can be overridden with the `-l` flag (local only).  If you have a properly configured MEGA folder & the MEGA CLI installed then this script can perform the upload for others as well but obviously not to the MEGA account used to share the official FujiNet VM.