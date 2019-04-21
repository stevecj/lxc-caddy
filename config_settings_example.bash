vm_name=lxc-caddy

#iso_images_dir=$scriptdir
iso_images_dir=$HOME/iso-images

vm_ubuntu_version=18.10

vm_hostname=$vm_name

vm_net_domain=$USER.local

hostonly_host_ip=192.168.99.1
hostonly_netmask=255.255.255.0

hostonly_vm_ip_cidr=192.168.99.2/24


virtual_machines_dir="$HOME/VirtualBox VMs"

# Note that this is a logical processor count. Each processor
# hyper-thred counts as a logical processor.
_processor_count_fraction=0.5
vm_processor_count=$(bc <<<"
    $(get_host_processor_count) * $_processor_count_fraction
")

_memory_size_fraction=0.375
vm_base_memory_size_MiB=$(bc <<<"
    $(get_host_os_ram_GiB) * 1024 * $_memory_size_fraction
")

_root_virtual_disk_GiB=10
root_virtual_disk_MiB=$(bc <<<"$_root_virtual_disk_GiB * 1024")

_containers_virtual_disk_GiB=40
containers_virtual_disk_MiB=$(bc <<<"$_containers_virtual_disk_GiB * 1024")

virtualbox_mac_app_path=/Applications/VirtualBox.app # /Contents/MacOS/UnattendedTemplates/ubuntu_preseed.cfg

_host_ssh_public_key_filename=$HOME/.ssh/id_rsa.pub
host_ssh_public_key=$(cat $_host_ssh_public_key_filename)

# Additional packages to install in the Ubuntu VM besides the
# lxc-caddy defaults.
addnl_vm_ubuntu_packages="git vim-pathogen"
#addnl_vm_ubuntu_packages="none"
