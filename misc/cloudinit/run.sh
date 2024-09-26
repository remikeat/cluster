#/bin/bash
#IMG=noble-server-cloudimg-amd64.img
IMG=nocloud_alpine-3.20.3-x86_64-bios-tiny-r0.qcow2
cloud-localds seed.img user-data meta-data
qemu-system-x86_64 -m 1024 -net nic -net user,hostfwd=tcp::10022-:22 -nographic \
    -drive file=$IMG,index=0,format=qcow2,media=disk \
    -drive file=seed.img,index=1,media=cdrom \
    -machine accel=kvm:tcg
