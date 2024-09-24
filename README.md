# Work in progress Nothing to see here
Figuring some FIPS stuff out.

## Setup
Install minimal RHEL 9 guest VM or physical device. Add `fips=1` boot
argument in the boot menu.

    cd ~/bootc-dracut-fips
    ssh-keygen -t rsa -f ~/.ssh/id_core
    ln -s ~/.ssh/id_core.pub .

    sudo ./register-and-update.sh
    sudo reboot

    cd ~/bootc-dracut-fips
    sudo ./config-bootc.sh
    sudo ./config-registry.sh
    sudo reboot

## Build a deployable ISO
Now, build a deployable ISO and install it as a guest VM.

    cd ~/bootc-dracut-fips
    ./build-install-iso.sh

Copy ISO file to the host. Then on the host,

    sudo ./install-edge-guest.sh
    sudo ./launch-edge-guest.sh

FAILED TO START WITH RHEL 9.4
