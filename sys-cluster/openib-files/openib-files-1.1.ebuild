# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB system files and examples"
HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"
S="${WORKDIR}/openib-userspace-${PV}/src/userspace/examples"

IUSE=""

DEPEND=""

src_install() {
	docinto examples/aio
	dodoc aio/*
	insinto /etc/udev/rules.d
	doins ${FILESDIR}/90-ib.rules
	doinitd ${FILESDIR}/openib
	insinto /etc/infiniband
	doins ${FILESDIR}/openib.conf
	insinto /etc/modules.d
	newins ${FILESDIR}/openib.modprobe openib
}

pkg_postinst() {
	/sbin/modules-update
	einfo "Configuration file installed in /etc/infiniband/openib.conf"
	einfo "To automatically initialize infiniband on boot, add openib to your"
	einfo "start-up scripts, like so:"
	einfo "\`rc-update add openib default\`"
}

