#!/bin/bash

get_host_processor_count() {
    if ! hostinfo | grep processors | grep logical | grep -E -o '\d+'; then
        echo "Failed to get host system's number of logical CPUs" 1>&2
        exit 1
    fi
}
export -f get_host_processor_count

get_host_os_ram_GiB() {
    if ! hostinfo | grep memory | grep -i primary | grep -i gigabytes \
        | grep -E -o '\d+([.]\d+)?'
    then
        echo "Failed to get host system's memory size in gigabytes" 1>&2
        exit 1
    fi
}
export -f get_host_os_ram_GiB

determine_existing_hostonly_net_info() {
    scan_result=$(VBoxManage list hostonlyifs | _scan_hostonly_net_info)
    eval $scan_result
}

_scan_hostonly_net_info() {
    cur_net_name=
    cur_net_ip=
    cur_net_mask=
    cur_net_dhcp=
    found_net_name=
    found_net_mask=
    found_net_dhcp=
    while read inp; do
        prop_name=${inp%%:*}
        prop_val=${inp#*:}
        prop_val=${prop_val// /}

        if [[ -z $prop_name ]]; then
            # Blank line encountered.
            if [[ $cur_net_ip == $hostonly_host_ip ]]; then
                break
            fi
            cur_net_name=
            cur_net_ip=
            cur_net_mask=
            cur_net_dhcp=
        fi

        case $prop_name in
          Name) cur_net_name=$prop_val;;
          IPAddress) cur_net_ip=$prop_val;;
          NetworkMask) cur_net_mask=$prop_val;;
          DHCP) cur_net_dhcp=$prop_val;;
        esac

    done

    if [[ $cur_net_ip == $hostonly_host_ip ]]; then
        # Last block before blank line or EOF was a match on IP address.
        found_net_name=$cur_net_name
        found_net_mask=$cur_net_mask
        found_net_dhcp=$cur_net_dhcp
    fi

    # Read and discard remaining input.
    while read inp; do
        :
    done

    echo "found_net_name=$found_net_name; found_net_mask=$cur_net_mask; found_net_dhcp=$cur_net_dhcp;"
}

determine_installer_iso_filename() {
    installer_iso_filename=ubuntu-$vm_ubuntu_version-server-amd64.iso
}
