# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2

DESCRIPTION="The lowest-level Growler library"
HOMEPAGE="http://www.nas.nasa.gov/~bgreen/growler/"
SRC_URI="${HOMEPAGE}/downloads/growler-link-${PV}.tar.gz"

SLOT="0"
LICENSE="NOSA"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran static tcpd"

RDEPEND="
	virtual/fortran
	dev-libs/boost
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

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
