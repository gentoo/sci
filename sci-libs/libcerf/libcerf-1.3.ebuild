# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils multilib

DESCRIPTION="library that provides an efficient and accurate implementation of complex error functions"
HOMEPAGE="http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
SRC_URI="http://apps.jcns.fz-juelich.de/src/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	autotools-utils_src_install

	#avoid collision with future glibc's cerf function
	mv "${ED}"/usr/share/man/man3/{,${PN}-}cerf.3 || die

	#htmldir is hard-coded 
	if use doc; then
		dohtml "${ED}"/usr/share/man/html/*
	fi
	rm -r "${ED}"/usr/share/man/html || die

	echo 'Libs.private: -lm' >> "${ED}/usr/$(get_libdir)/pkgconfig/${PN}.pc" || die
}
