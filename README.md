# Building

Build with `snapcraft` with the `trx_lms7002m-linux-2017-02-10.tar.gz` and `lteenb-linux-2017-02-10.tar.gz` tarballs in the parent directory (if you have different names, edit `snap/snapcraft.yaml`). `liblimesuite-dev` will be installed with APT if missing.

# Installation

To use on a fresh Ubuntu 16.04 or later system (14.04 should work too but untested), make sure snaps are working:
```shell
snap version
sudo snap install hello-world
hello-world
```

Then install with:
```shell
sudo snap install --devmode lteenb*.snap
```

(this will be `sudo snap install --devmode lteenb` when the snap is in the a store)

Do the system setup with:
```shell
sudo lteenb-lool.set-rfbackend limeSDR
sudo lteenb-lool.set-license ~/lteenb.key
```

# Running

This is useful to tune the system to the right values:
```shell
sudo lteenb-lool.systune
```

Run with:
```shell
sudo lteenb-lool.lteenb /snap/lteenb-lool/current/config/enb.cfg
```

