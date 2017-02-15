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
    ensure_root
    ensure_rfbackend
    ensure_license

    "$SNAP/lteenb" "$@"
}

set_license() {
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

    ln -sf "$SNAP/config/$1" "$SNAP_DATA/rf_driver"
}

