vm_name=lxc-caddy

#iso_images_dir=$scriptdir
iso_images_dir=$HOME/iso-images

vm_ubuntu_version=18.10

vm_hostname=$vm_name

vm_net_domain=$USER.local

# The host IP address and netmask of an existing VirtualBox
# Host-only network.
hostonly_host_ip=192.168.56.1
hostonly_netmask=255.255.255.0

# The IP address that the new VM's second network adapter should
# have on the host-only network.  If DHCP is enabled on the
# host-only network, then this should be outside of the DHCP
# range.
hostonly_vm_ip_cidr=192.168.56.70/24


virtual_machines_dir="$HOME/VirtualBox VMs"

# Note that this is a logical processor count. Each processor
# hyper-thread counts as 1 logical processor.
_processor_count_fraction=0.5
vm_processor_count=$(bc <<<"
    $(get_host_processor_count) * $_processor_count_fraction
")

_memory_size_fraction=0.375
vm_base_memory_size_MiB=$(bc <<<"
    $(get_host_os_ram_GiB) * 1024 * $_memory_size_fraction
")

# The size of the virtual disk used for the VM's root volume.
_root_virtual_disk_GiB=10
root_virtual_disk_MiB=$(bc <<<"$_root_virtual_disk_GiB * 1024")

# The size of the virtual disk used for the VM's volume that is
# used for containers.
_containers_virtual_disk_GiB=40
containers_virtual_disk_MiB=$(bc <<<"$_containers_virtual_disk_GiB * 1024")

virtualbox_mac_app_path=/Applications/VirtualBox.app

# The public key file on the host that should be added as an
# authorized key in the guest OS.
_host_ssh_public_key_filename=$HOME/.ssh/id_rsa.pub
host_ssh_public_key=$(cat $_host_ssh_public_key_filename)

# Additional packages to install in the Ubuntu VM besides the
# lxc-caddy defaults.  A space-separated list of package names
# or "none" for no additional packages.
addnl_vm_ubuntu_packages="git vim-pathogen"
#addnl_vm_ubuntu_packages="none"
