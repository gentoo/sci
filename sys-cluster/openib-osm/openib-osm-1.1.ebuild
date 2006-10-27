# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenSM - InfiniBand Subnet Manager and Administration for OpenIB"

HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"
S="${WORKDIR}/openib-userspace-${PV}/src/userspace/management/osm"

IUSE=""

DEPEND="=sys-cluster/libibmad-${PV}"
RDEPEND="$DEPEND
		 =sys-cluster/openib-files-${PV}
		 net-misc/iputils"    # for 'ping'

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README COPYING NEWS ChangeLog
	docinto doc
	dodoc doc/*
	insinto /etc
	if [[ $BRANCH="1.0" ]]; then
		doins ${FILESDIR}/opensm.conf
		dobin ${FILESDIR}/sldd.sh
	else
		doins ${S}/scripts/opensm.conf
		dobin ${S}/scripts/sldd.sh
	fi
	doinitd ${FILESDIR}/opensmd
}

pkg_postinst() {
	einfo "To automatically configure the infiniband subnet manager on boot,"
	einfo "edit /etc/opensm.conf and add opensmd to your start-up scripts:"
	einfo "\`rc-update add opensmd default\`"
}

