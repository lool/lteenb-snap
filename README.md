# Building

Build with `snapcraft` with the `trx_lms7002m-linux-2017-02-10.tar.gz` and
`lteenb-linux-2017-02-10.tar.gz` tarballs in the parent directory (if you have
different names, edit `snap/snapcraft.yaml`). `liblimesuite-dev` will be
installed with APT if missing.

# Installation

To use on an Ubuntu 16.04 or later system (14.04 should work too but untested),
install stable updates and make sure snaps are working:
```shell
snap version
sudo snap install hello-world
hello-world
```

Then install with:
```shell
sudo snap install --devmode lteenb*.snap
```
(or `sudo snap install --devmode lteenb` to install from a store)

Configure radio backend and license with:
```shell
sudo lteenb-lool.set-rfbackend limeSDR
sudo lteenb-lool.set-license ~/lteenb.key
```

Tune the system to the right values; this should probably go to /etc/rc.local
or similar:
```shell
sudo lteenb-lool.systune
```

Finally, restart the daemon:
```shell
sudo systemctl restart snap.lteenb-lool.lteenb
```

# Operation

The configuration template is generated under
`/var/snap/lteenb-lool/current/enb.cfg` during first run and overrides as
little as possible from the shipped configs which are under
`/snap/lteenb-lool/current/config/`.

The default log file is `/var/snap/lteenb-lool/current/logs/enb0.log`.

Use journalctl to check the lteenb output:
```shell
sudo journalctl -u snap.lteenb-lool.lteenb
```

To run lteenb manually, stop the service and use snap run:
```shell
sudo systemctl stop snap.lteenb-lool.lteenb
sudo snap run lteenb-lool.lteenb
```

