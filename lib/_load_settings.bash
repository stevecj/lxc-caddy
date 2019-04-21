if [[ -z $settings_script ]]; then
    settings_script=$scriptdir/config_settings.bash
fi

if [[ ! -f $settings_script ]]; then
    cat <<EOF >&2

No "$settings_script" settings script file was found.
You can create one by copying from the config_settings_example.bash
file and customizing it as you wish, or you can specify another
configuration filename (e.g. config_settings_example.bash) as an
argument to this command.

EOF
    exit 1
fi

config_opts=(
    vm_name iso_images_dir
    vm_ubuntu_version vm_hostname
    hostonly_host_ip
    hostonly_netmask
    hostonly_vm_ip_cidr
    virtual_machines_dir
    vm_processor_count
    vm_base_memory_size_MiB
    root_virtual_disk_MiB
    containers_virtual_disk_MiB
    virtualbox_mac_app_path
    host_ssh_public_key
    addnl_vm_ubuntu_packages
)

# Initialize config-setting variables.
for opt in ${config_opts[@]}; do
    eval "$opt="
done

# Evaluate the settings file to assign config-setting variables.
source $settings_script

# Override any config-setting values with env var values where given.
for opt in ${config_opts[@]}; do
    envvar=LXCAD_$( echo $opt | tr a-z A-Z )
    envval=$(eval "echo \$$envvar")
    if [[ -n $envval ]]; then
        eval "$opt='\$envval'"
    fi
    if [[ -z $( eval "echo \$$opt" ) ]]; then
        echo -e "\nNo value provided in '$opt' config setting or '$envvar' variable\n" >&2
        case $opt in
        host_ssh_public_key)
            cat <<EOF
If you have not yet generated an ssh keypair on your host system
and need to learn how to do that, see
https://www.techrepublic.com/article/how-to-generate-ssh-keys-on-macos-mojave/

EOF
            ;;
        esac
        exit 1
    fi
done

if [[ ! -e $virtualbox_mac_app_path ]]; then
    cat <<EOF >&2
The value given for the path to the VirtualBox Mac application is
$virtualbox_mac_app_path, but it doesn't seem to be there.
EOF
    exit 1
fi

# Clean config values.
vm_processor_count=${vm_processor_count%.*}
vm_base_memory_size_MiB=${vm_base_memory_size_MiB%.*}
root_virtual_disk_MiB=${root_virtual_disk_MiB%.*}
containers_virtual_disk_MiB=${containers_virtual_disk_MiB%.*}

# Derived config values
hostonly_vm_ip=${hostonly_vm_ip_cidr%%\/*}
