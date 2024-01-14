packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }    
  }
}

source "qemu" "fujinet" {
  iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
  iso_checksum      = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
  ssh_username      = "fujinet"
  ssh_password      = "online"
  ssh_wait_timeout  = "30s"
  boot_wait         = "10s"
  disk_size         = "10000"
  format            = "qcow2"
  headless          = true
  accelerator       = "kvm"
  net_device        = "virtio-net"
  output_directory  = "output-qemu"
  vm_name           = "debian-10-qemu"
  http_directory    = "http"
  boot_command      = [
    "<esc><esc><enter><wait>",
    "/install.amd/vmlinuz",
    " auto=true ",
    " hostname={{ .Name }} ",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    " debian-installer=en_US auto ",
    " locale=en_US.UTF-8 ",
    " keymap=us ",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    " -- <enter>"
  ]
}

build {
  name    = "fujinet-packer"
  sources = [
    "source.qemu.fujinet"
  ]

  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo debconf-set-selections <<< 'debconf debconf/frontend select Noninteractive'",
      "sudo apt-get update",
      "sudo apt-get install -y openssh-server sudo",
      "sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo systemctl enable ssh",
      "sudo systemctl start ssh",
      "sudo apt-get clean"
      ]
  }
}
