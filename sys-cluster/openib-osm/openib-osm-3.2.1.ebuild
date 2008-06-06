# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~x86 ~amd64"

DESCRIPTION="OpenSM - InfiniBand Subnet Manager and Administration for OpenIB"

HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/downloads/management/opensm-${PV}.tar.gz"
S="${WORKDIR}/opensm-${PV}"

IUSE=""

DEPEND="sys-cluster/libibmad"
RDEPEND="$DEPEND
	 sys-cluster/openib-files
	 net-misc/iputils"    # for 'ping'

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README NEWS ChangeLog
	doman man/*
	newconfd "${S}/scripts/opensm.sysconfig" opensm
	newinitd "${FILESDIR}/opensm.init.d" opensm
	insinto /etc/logrotate.d
	newins "${S}/scripts/opensm.logrotate" opensm
	insinto /etc/opensm
	doins "${S}/scripts/opensm.conf"
	dosbin "${S}/scripts/sldd.sh"
}

pkg_postinst() {
	einfo "To automatically configure the infiniband subnet manager on boot,"
	einfo "edit /etc/opensm.conf and add opensm to your start-up scripts:"
	einfo "\`rc-update add opensm default\`"
}

