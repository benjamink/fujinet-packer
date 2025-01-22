packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
    vmware = {
      version = "~> 1"
      source  = "github.com/hashicorp/vmware"
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

variable "sources" {
  type        = list(string)
  description = "Specify which source type(s) to build"
  default = [
    "source.virtualbox-iso.fujinet",
    "source.vmware-iso.fujinet",
    "source.qemu.fujinet"
  ]
}

//"source.qemu.fujinet",

locals {
  username        = "fujinet"
  altirra_zip_url = "https://virtualdub.org/downloads/Altirra-4.20.zip"
  iso_url         = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"
  iso_checksum    = "sha256:1257373c706d8c07e6917942736a865dfff557d21d76ea3040bb1039eb72a054"
}

// QEMU source is currently unused & untested.  The below may be developed & used at a future time.
source "qemu" "fujinet" {
  iso_url          = local.iso_url
  iso_checksum     = local.iso_checksum
  ssh_username     = local.username
  ssh_password     = "online"
  ssh_wait_timeout = "3600s"
  ssh_pty          = true
  boot_wait        = "10s"
  disk_size        = "25000"
  disk_compression = true
  format           = "qcow2"
  headless         = true
  cpus             = 4
  accelerator      = "kvm"
  memory           = 8192
  net_device       = "virtio-net"
  output_directory = "output-qemu"
  vm_name          = "fujinet-debian12-qemu.qcow2"
  http_directory   = "http"
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/qemu-preseed.cfg netcfg/get_hostname=fujinet-vm<enter><wait><enter>"
  ]
  qemuargs = [
    ["-m", "4096M"],
    ["-smp", "2"]
  ]
  shutdown_command = "echo 'online' | sudo -S shutdown -P now"
}

// VMware source is currently unused & untested.  The below may be developed & used at a future time.
source "vmware-iso" "fujinet" {
  iso_url             = local.iso_url
  iso_checksum        = local.iso_checksum
  ssh_username        = local.username
  ssh_password        = "online"
  ssh_wait_timeout    = "3600s"
  ssh_pty             = true
  boot_wait           = "10s"
  disk_size           = "25000"
  headless            = true
  format              = "ova"
  cpus                = 4
  memory              = 8192
  output_directory    = "output-vmware"
  vm_name             = "fujinet-debian12-vmware"
  vnc_disable_password = true
  http_directory      = "http"
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/vmware-preseed.cfg",
    "<enter><wait><enter>"
  ]
  shutdown_command = "echo 'online' | sudo -S shutdown -P now"
}

source "virtualbox-iso" "fujinet" {
  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "FujiNet Development VM (version ${var.vm_version})",
    "--version", var.vm_version
  ]
  format                    = "ova"
  iso_url                   = local.iso_url
  iso_checksum              = local.iso_checksum
  ssh_username              = local.username
  ssh_password              = "online"
  ssh_wait_timeout          = "3600s"
  boot_wait                 = "10s"
  disk_size                 = "25000"
  headless                  = true
  cpus                      = "4"
  memory                    = "8192"
  output_directory          = "output"
  vm_name                   = "fujinet-debian12-vbox"
  http_directory            = "http"
  guest_os_type             = "Debian_64"
  iso_interface             = "sata"
  hard_drive_interface      = "sata"
  gfx_controller            = "vmsvga"
  gfx_vram_size             = 64
  guest_additions_mode      = "upload"
  guest_additions_interface = "sata"
  guest_additions_path      = "VBoxGuestAdditions.iso"
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/vbox-preseed.cfg netcfg/get_hostname=fujinet-vm<enter><wait><enter>"
  ]
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--memory", "4096"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--draganddrop", "bidirectional"],
    ["modifyvm", "{{.Name}}", "--clipboard", "bidirectional"],
    ["modifyvm", "{{.Name}}", "--audioout", "on"],
  ]
  shutdown_command = "echo 'online' | sudo -S shutdown -P now"
}

build {
  name    = "build"
  sources = var.sources

  provisioner "file" {
    source      = "files/FujiNet-Logo-Wallpaper1.png"
    destination = "/tmp/wallpaper.png"
  }

  provisioner "file" {
    source      = "files/cocomame.tar.gz"
    destination = "/tmp/cocomame.tar.gz"
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

  /*
  provisioner "shell" {
    scripts = [
      "scripts/vmware-tools.sh",
    ]
    only = ["vmware-iso.fujinet"]
  }
  */

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "P_USERNAME=${local.username}",
      "P_FN_PATH=/home/${local.username}/FujiNet",
      "CMAKE_COLOR_DIAGNOSTICS=OFF",
      "PLATFORMIO_NO_ANSI=True"
    ]
    scripts = [
      "scripts/virtualbox.sh",
    ]
    only = ["virtualbox-iso.fujinet"]
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
      "scripts/fujinet-sudoers.sh",
      "scripts/lightdm-greeter-fn.sh",
      #"scripts/lightdm-greeter-vcf.sh",
      "scripts/user-setup.sh",
      "scripts/tnfs-install.sh",
      "scripts/install-dir2atr.sh",
      "scripts/install-wine.sh",
      "scripts/setup-fujinet-apps.sh",
      "scripts/build-install-fn-pc-apple.sh",
      "scripts/build-install-fn-pc-atari.sh",
      "scripts/build-install-fn-pc-coco.sh",
      "scripts/install-altirra.sh",
      "scripts/install-applewin-linux.sh",
      "scripts/install-cocomame.sh",
      "scripts/firstboot-setup.sh",
      "scripts/xfce-fujinet-menu.sh"
    ]
  }

  provisioner "file" {
    source      = "files/run-nc"
    destination = "/home/${local.username}/.local/bin/run-nc"
  }

  provisioner "file" {
    source      = "files/altirra-logo.png"
    destination = "/home/${local.username}/Pictures/altirra-logo.png"
  }

  provisioner "file" {
    source      = "files/FujiNet-Logo-NoText-black.png"
    destination = "/home/${local.username}/Pictures/fn-logo-black.png"
  }

  provisioner "file" {
    source      = "files/upgrade_vm"
    destination = "/home/${local.username}/.local/bin/upgrade_vm"
  }

  provisioner "shell" {
    scripts = [
      "scripts/cleanup.sh"
    ]
  }
}
