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

source "virtualbox-iso" "fujinet" {
  iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
  iso_checksum      = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
  ssh_username      = local.username
  ssh_password      = "online"
  ssh_wait_timeout  = "300s"
  boot_wait         = "10s"
  disk_size         = "10000"
  headless          = true
  #cpus              = "2"
  #memory            = "4096"
  output_directory  = "output-qemu"
  vm_name           = "fujinet-debian12"
  http_directory    = "http"
  guest_os_type     = "Debian_64"
  vrdp_bind_address = "0.0.0.0"
  vrdp_port_min     = 5900
  vrdp_port_max     = 5901
  boot_command = [
    "<wait><esc><wait>",
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg netcfg/get_hostname=fujinet-vm<enter><wait><enter>"
  ]
  #vboxmanage = [
  #  ["modifyvm", "{{.Name}}", "--memory", "4096"],
  #  ["modifyvm", "{{.Name}}", "--cpus", "2"]
  #]
  shutdown_command = "echo 'online' | sudo -S shutdown -P now"
}

build {
  name = "fujinet-packer"
  sources = [
    "source.qemu.fujinet"
  ]

  provisioner "file" {
    source      = "files/wallpaper.png"
    destination = "/tmp/wallpaper.png"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "P_USERNAME=${local.username}",
      "P_ALTIRRA_ZIP_URL=${local.altirra_zip_url}",
      "P_FN_PATH=/home/${local.username}/FujiNet"
    ]
    scripts = [
      "scripts/lightdm-greeter.sh",
      "scripts/user-setup.sh",
      "scripts/tnfs-install.sh",
      "scripts/install-wine.sh",
      "scripts/setup-fujinet-apps.sh",
      "scripts/build-install-fn-pc-apple.sh",
      "scripts/build-install-fn-pc-atari.sh",
      "scripts/install-altirra.sh",
      "scripts/install-applewin-linux.sh"
    ]
  }
}
