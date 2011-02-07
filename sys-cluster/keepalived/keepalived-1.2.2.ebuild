# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit flag-o-matic autotools base

DESCRIPTION="A strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="http://www.keepalived.org/"
SRC_URI="http://www.keepalived.org/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="debug +lvs"

RDEPEND="dev-libs/popt
	sys-apps/iproute2
	dev-libs/openssl
	lvs? ( sys-cluster/ipvsadm )"
DEPEND="${RDEPEND}
	=sys-kernel/linux-headers-2.6*"

use lvs && PATCHES=( "${FILESDIR}/${P}-do-not-need-kernel-sources.patch" )

src_prepare() {
	base_src_prepare

	if use lvs; then
		# Prepare a suitable copy of the IPVS headers
		# So that we don't need kernel sources at all!
		mkdir -p "${S}"/include/net || die "Failed to prepare ipvs header directory"
		cp -f "${FILESDIR}"/${PN}-1.2.1-linux-2.6.35-ip_vs.h \
			"${S}"/include/net/ip_vs.h || die "Failed to add ipvs header"

		# Ensure that keepalived can find the header that we are injecting
		append-flags -I"${S}"/include

		eautoreconf
	fi
}

src_configure() {
	STRIP=/bin/true \
	econf \
		--enable-vrrp \
		$(use_enable lvs) \
		$(use_enable lvs lvs-syncd) \
		$(use_enable debug)
}

src_install() {
	base_src_install

	newinitd "${FILESDIR}"/init-keepalived keepalived || die

	dodoc doc/keepalived.conf.SYNOPSIS || die
	dodoc README CONTRIBUTORS INSTALL VERSION ChangeLog AUTHOR TODO || die

	docinto genhash
	dodoc genhash/README genhash/AUTHOR genhash/ChangeLog genhash/VERSION || die
	# This was badly named by upstream, it's more HOWTO than anything else.
	newdoc INSTALL INSTALL+HOWTO || die

	# Security risk to bundle SSL certs
	rm -f "${D}"/etc/keepalived/samples/*.pem
	# Clean up sysvinit files
	rm -rf "${D}"/etc/sysconfig "${D}"/etc/rc.d/
}
