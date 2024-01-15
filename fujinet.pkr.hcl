packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "fujinet" {
  iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
  iso_checksum     = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
  ssh_username     = "fujinet"
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
    "auto lowmem/low=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg netcfg/get_hostname=fujinet-vm DEBCONF_DEBUG=5<enter><wait><enter>"
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
      "sleep 30",
      "sudo apt install -y vim samba samba-common-bin"
    ]
  }
}
