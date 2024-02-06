#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later

# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cmdline 94 "$moddir/rapl.sh"
}
