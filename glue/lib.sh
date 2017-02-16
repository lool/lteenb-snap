die() {
    echo "$@" >&2
    exit 1
}

ensure_license() {
    if ! [ -r "$SNAP_DATA/lteenb.key" ]; then
        die "Please set license: $SNAP_NAME.set-license <license file>"
    fi

    AMARISOFT_PATH="$SNAP_DATA"
    export AMARISOFT_PATH
}

ensure_rfbackend() {
    if ! [ -e "$SNAP_DATA/rf_driver" ]; then
        die "Please set rf backend: $SNAP_NAME.set-rfbackend <license file>"
    fi
}

ensure_root() {
    if [ `id -u` != 0 ]; then
        die "Please run as root"
    fi
}

launch_lteenb() {
    local logdir="/var/snap/$SNAP_NAME/current/logs"
    local config="$SNAP_DATA/enb.cfg"

    ensure_root
    ensure_rfbackend
    ensure_license

    if ! [ -d "$logdir" ]; then
        mkdir -p "$logdir"
    fi
    if ! [ -f "$config" ]; then
        cat >"$config" <<EOF
{
    include "/snap/$SNAP_NAME/current/config/enb.cfg",

    /* Override default values */
    log_filename: "$logdir/enb0.log",

    cell_list: [{
        dl_earfcn: 2450, /* DL 874Mhz, UL: 829Mhz, band 5 for MWC 2017 */
        n_rb_dl: 15,     /* 3Mhz */
        sib_sched_list: [ "/snap/$SNAP_NAME/current/config/sib23_rb15.asn" ],
    }]
}
EOF
    fi

    # liblimesuite writes caches to $HOME/.limesuite/
    export HOME="$SNAP_DATA"

    "$SNAP/lteenb" "$config" "$@"
}

set_license() {
    local license

    ensure_root

    if [ "$#" != 1 ]; then
        die "Usage: $0 <license-file>"
    fi

    if ! [ -r "$1" ]; then
        die "Can't read license $1"
    fi

    license="$SNAP_DATA/lteenb.key"
    touch "$license"
    chmod 600 "$license"
    cat "$1" >"$license"
}

set_rfbackend() {
    ensure_root

    if [ "$#" != 1 ]; then
        die "Usage: $0 <rf backend>"
    fi

    if ! [ -e "$SNAP/config/$1" ]; then
        die "No such backend $1"
    fi

    ln -sf "/snap/$SNAP_NAME/current/config/$1" "$SNAP_DATA/rf_driver"
}

