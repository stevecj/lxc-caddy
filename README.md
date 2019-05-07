# lxc-caddy
Creates a VirtualBox VM for hosting LXC/LXD containers with minimal fuss

Minimal instructions (will flesh this out in the future):

1. Install VirtualBox. See https://www.virtualbox.org/ .
1. Install md5sum on the Mac host system (`brew install md5sum` if using Homebrew).
1. Copy config_settings_example.bash to config_settings.bash
1. Edit config_settings.bash and customize as desired.
1. Execute get-ubuntu-installer-iso-image.
1. Execute setup-vm-with-ubuntu.
1. Execute vm-setup-epilogue
