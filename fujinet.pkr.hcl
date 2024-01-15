packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

locals {
  username                  = "fujinet"
  fujinet_pc_bundle_zip_url = "https://github.com/a8jan/fujinet-pc-launcher/releases/download/release-2401.1/fujinet-pc-bundle_2401.1_windows-x64.zip"
  altirra_zip_url           = "https://virtualdub.org/downloads/Altirra-4.20.zip"
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
  accelerator      = "kvm"
  net_device       = "virtio-net"
  output_directory = "output-qemu"
  vm_name          = "debian-12-qemu"
  http_directory   = "http"
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg netcfg/get_hostname=fujinet-vm<enter><wait><enter>"
  ]
  qemuargs = [
    ["-m", "2048M"],
  ]
}

build {
  name = "fujinet-packer"
  sources = [
    "source.qemu.fujinet"
  ]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    inline = [
      "sudo apt install -y vim samba samba-common-bin xfce4 playonlinux",
      "sudo useradd -c 'tnfsd user' -U -m -d /tnfs -r tnfs",
      "sudo usermod -a -G tnfs ${local.username}"
    ]
  }

  provisioner "file" {
    source      = "files/tnfs/smb.conf"
    destination = "/tmp/tnfs-smb.conf"
  }

  provisioner "file" {
    source      = "files/lightdm/lightdm-gtk-greeter.conf"
    destination = "/tmp/lightdm-gtk-greeter.conf"
  }

  provisioner "file" {
    source      = "files/user/${local.username}/wallpaper.png"
    destination = "/home/${local.username}/Pictures/wallpaper.png"
  }

  provisioner "shell" {
    inline = [
      "sudo cat /tmp/tnfs-smb.conf >> /etc/samba/smb.conf",
      "sudo mv /tmp/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf",
      "sudo cp /home/${local.username}/Pictures/wallpaper.png /etc/lightdm/login-logo.png",
      "rm /tmp/tnfs-smb.conf"
    ]
  }

  provisioner "file" {
    source      = "files/user/${local.username}/desktop/"
    destination = "/home/${local.username}/Desktop"
  }

  provisioner "shell" {
    inline = [
      "curl -sLo /home/${local.username}/Downloads/fujinet-pc-bundle.zip ${local.fujinet_pc_bundle_zip_url}",
      "curl -sLo /home/${local.username}/Downloads/altirra.zip ${local.altirra_zip_url}",
      "mkdir /home/${local.username}/FujiNet",
      "cd /home/${local.username}/FujiNet",
      "unzip /home/${local.username}/Downloads/fujinet-pc-bundle.zip",
      "unzip /home/${local.username}/Downloads/altirra.zip",
      "rm -f /home/${local.username}/Downloads/*.zip"
    ]
  }
}
