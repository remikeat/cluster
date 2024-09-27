#/bin/bash
IMG=noble-server-cloudimg-amd64.img

qemu-img create -f qcow2 -b $IMG -F qcow2 overlay.img
cloud-localds seed.img user-data meta-data
qemu-system-x86_64 -m 1024 -net nic -net user,hostfwd=tcp::10022-:22 -nographic \
    -drive file=overlay.img,index=0,format=qcow2,media=disk \
    -drive file=seed.img,index=1,media=cdrom \
    -machine accel=kvm:tcg
