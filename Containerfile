FROM registry.redhat.io/rhel9/rhel-bootc:9.4

# update initrd to include the fips module
RUN    mkdir -p /usr/lib/dracut/dracut.conf.d \
    && cat <<EOF >> /usr/lib/dracut/dracut.conf.d/40-fips.conf
add_dracutmodules+=" fips "
EOF
RUN    kver=$(cd /usr/lib/modules && echo *) \
    && dracut -vf /usr/lib/modules/$kver/initramfs.img $kver

# update the kernel args to include FIPS and STIG arguments
ARG BOOT_KARGS
RUN    mkdir -p /usr/lib/bootc/kargs.d \
    && cat <<EOF >> /usr/lib/bootc/kargs.d/01-fips-stig.toml
kargs = $BOOT_KARGS 
EOF
