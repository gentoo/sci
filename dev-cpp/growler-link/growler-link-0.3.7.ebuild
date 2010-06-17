# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Growler-Link: the lowest-level Growler library."
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-link-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="doc tcpd static fortran"

RDEPEND=">=dev-libs/boost-1.33.1
		tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gcc4.patch
}

src_configure() {
	econf \
		$(use_enable doc) \
		$(use_enable tcpd) \
		$(use_enable static) \
		$(use_enable fortran)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS AUTHORS NOSA ChangeLog || die
}

