# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

OFED_VER="1.4"
OFED_SUFFIX="1.ofed1.4"

inherit openib

DESCRIPTION="OpenSM - InfiniBand Subnet Manager and Administration for OpenIB"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=sys-infiniband/libibmad-1.2.3_p20081118
	>=sys-infiniband/libibumad-1.2.3_p20081118"
RDEPEND="$DEPEND
	 sys-infiniband/openib-files
	 net-misc/iputils"

src_configure() {
	econf \
		--enable-perf-mgr \
		--enable-default-event-plugin \
		--with-osmv="openib"
}

src_install() {
	default
	newconfd "${S}/scripts/opensm.sysconfig" opensm
	newinitd "${FILESDIR}/opensm.init.d" opensm
	insinto /etc/logrotate.d
	newins "${S}/scripts/opensm.logrotate" opensm
	# we dont nee this int script
	rm "${D}/etc/init.d/opensmd" || die "Dropping of upstream initscript failed"
}

pkg_postinst() {
	einfo "To automatically configure the infiniband subnet manager on boot,"
	einfo "edit /etc/opensm.conf and add opensm to your start-up scripts:"
	einfo "\`rc-update add opensm default\`"
}
