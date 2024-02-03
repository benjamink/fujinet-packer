packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "vm_version" {
  type        = string
  description = "Version for the built VM appliance"
  default     = "test"
}

locals {
  username        = "fujinet"
  altirra_zip_url = "https://virtualdub.org/downloads/Altirra-4.20.zip"
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
  cpus             = 4
  accelerator      = "kvm"
  memory           = 8192
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
  shutdown_command = "echo 'online' | sudo -S shutdown -P now"
}

source "virtualbox-iso" "fujinet" {
  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "FujiNet Development VM",
    "--version", var.vm_version
  ]
  format                    = "ova"
  iso_url                   = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
  iso_checksum              = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
  ssh_username              = local.username
  ssh_password              = "online"
  ssh_wait_timeout          = "3600s"
  boot_wait                 = "10s"
  disk_size                 = "25000"
  headless                  = true
  cpus                      = "4"
  memory                    = "8192"
  output_directory          = "output-qemu"
  vm_name                   = "fujinet-debian12-vbox-${var.vm_version}"
  http_directory            = "http"
  guest_os_type             = "Debian_64"
  iso_interface             = "sata"
  hard_drive_interface      = "sata"
  gfx_controller            = "vmsvga"
  gfx_vram_size             = 33
  guest_additions_mode      = "upload"
  guest_additions_interface = "sata"
  guest_additions_path      = "VBoxGuestAdditions.iso"
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg netcfg/get_hostname=fujinet-vm<enter><wait><enter>"
  ]
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "4096"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]
  shutdown_command = "echo 'online' | sudo -S shutdown -P now"
}

build {
  name = "fujinet-packer"
  sources = [
    "source.virtualbox-iso.fujinet"
  ]

  provisioner "file" {
    source      = "files/FujiNet-Logo-Wallpaper1.png"
    destination = "/tmp/wallpaper.png"
  }

  /*
  provisioner "file" {
    source      = "files/VCF-Logo-Wallpaper1.png"
    destination = "/tmp/wallpaper.png"
  }
  */

  provisioner "file" {
    source      = "files/FujiNet-Logo-NoText.png"
    destination = "/tmp/login-icon.png"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "P_USERNAME=${local.username}",
      "P_ALTIRRA_ZIP_URL=${local.altirra_zip_url}",
      "P_FN_PATH=/home/${local.username}/FujiNet",
      "CMAKE_COLOR_DIAGNOSTICS=OFF",
      "PLATFORMIO_NO_ANSI=True"
    ]
    scripts = [
      "scripts/virtualbox.sh",
      "scripts/lightdm-greeter-fn.sh",
      #"scripts/lightdm-greeter-vcf.sh",
      "scripts/user-setup.sh",
      "scripts/tnfs-install.sh",
      "scripts/install-wine.sh",
      "scripts/setup-fujinet-apps.sh",
      "scripts/build-install-fn-pc-apple.sh",
      "scripts/build-install-fn-pc-atari.sh",
      "scripts/install-altirra.sh",
      "scripts/install-applewin-linux.sh",
      "scripts/firstboot-setup.sh"
    ]
  }

  provisioner "file" {
    source      = "files/altirra-logo.png"
    destination = "/home/${local.username}/Pictures/altirra-logo.png"
  }

}
