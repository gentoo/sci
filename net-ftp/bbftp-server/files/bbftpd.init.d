#!/sbin/openrc-run
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Based on opensm script from openfabrics.org,
#  Copyright (c) 2006 Mellanox Technologies. All rights reserved.
#  Distributed under the terms of the GNU General Public License v2

depend() {
    after net    # ip net seems to be needed to perform management.
}

prog=/usr/bin/bbftpd
pidfile=/var/run/bbftpd.pid

start() {
    ebegin "Starting bbftpd"
    start-stop-daemon --start --pidfile $pidfile --exec $prog -- -b $OPTIONS
    eend $?
}

stop() {
    ebegin "Stopping bbftpd"
    start-stop-daemon --stop --pidfile $pidfile --exec $prog
    eend $?
}

