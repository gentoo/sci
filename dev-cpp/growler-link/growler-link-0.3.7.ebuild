# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /CVS/groups/vistech/bgreen-overlay/dev-cpp/growler-link/growler-link-0.3.1.ebuild,v 1.1.1.1 2007/10/12 20:18:26 bgreen Exp $

SLOT="0"
LICENSE="NOSA"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Growler-Link: the lowest-level Growler library.  Support for dynamic linking, components, logging, etc."
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-link-${PV}.tar.gz"

IUSE="doc tcpd static fortran"

RDEPEND=">=dev-libs/boost-1.33.1
		tcpd? ( sys-apps/tcp-wrappers )"

DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

src_compile() {
	econf \
		$(use_enable doc) \
		$(use_enable tcpd) \
		$(use_enable static) \
		$(use_enable fortran) \
		--enable-fast-install \
		|| die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS AUTHORS NOSA ChangeLog
}

