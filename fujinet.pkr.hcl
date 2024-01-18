packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

locals {
  username           = "fujinet"
  fujinet_platformio_url = "https://github.com/FujiNetWIFI/fujinet-platformio.git"
  fujinet_apps_url = "https://github.com/FujiNetWIFI/fujinet-apps.git"
  altirra_zip_url    = "https://virtualdub.org/downloads/Altirra-4.20.zip"
}

source "qemu" "fujinet" {
  iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
  iso_checksum     = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
  ssh_username     = local.username
  ssh_password     = "online"
  ssh_wait_timeout = "3600s"
  ssh_pty          = true
  boot_wait        = "10s"
  disk_size        = "10000"
  format           = "qcow2"
  headless         = true
  net_device       = "virtio-net"
  output_directory = "output-qemu"
  vm_name          = "debian-12-qemu.qcow2"
  http_directory   = "http"
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg netcfg/get_hostname=fujinet-vm<enter><wait><enter>"
  ]
  qemuargs = [
    ["-m", "8192M"],
    ["-smp", "2"]
  ]
}

build {
  name = "fujinet-packer"
  sources = [
    "source.qemu.fujinet"
  ]

  provisioner "file" {
    source      = "files/wallpaper.png"
    destination = "/tmp"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "P_USERNAME=${local.username}",
      "P_ALTIRRA_ZIP_URL=${local.altirra_zip_url}",
      "P_FUJINET_PLATFORMIO_URL=${local.fujinet_platformio_url}",
      "P_FUJINET_APPS_URL=${local.fujinet_apps_url}",
      "P_CODE_PATH=/home/${local.username}/code"
    ]
    scripts = [
      "scripts/tnfs-install.sh",
      "scripts/user-setup.sh",
      "scripts/lightdm-greeter.sh",
      "scripts/install-wine.sh",
      "scripts/clone-fujinet-repos.sh",
      "scripts/build-install-fn-pc-apple.sh",
      "scripts/build-install-fn-pc-atari.sh",
      "scripts/install-altirra.sh",
      "scripts/install-applewin-linux.sh"
    ]
  }

  provisioner "file" {
    source      = "files/user/${local.username}/desktop/"
    destination = "/home/${local.username}/Desktop"
  }

  provisioner "file" {
    source      = "files/user/initial-setup.sh"
    destination = "/home/${local.username}/"
  }
}
