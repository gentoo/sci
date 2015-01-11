# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils eutils fortran-2

DESCRIPTION="Library for reading and writing matlab files"
HOMEPAGE="http://sourceforge.net/projects/matio/"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
# disabling (until fix) doxygen doc generation
IUSE="examples fortran static-libs"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
#DEPEND="doc? ( app-doc/doxygen virtual/latex-base )"
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}"-autotools.patch )

src_configure() {
	local myeconfargs=(
		--disable-test
		#$(use_enable doc docs)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	#if use doc; then
	#	insinto /usr/share/doc/${PF}
	#	doins -r doxygen/html || die
	#fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/test*
		insinto /usr/share/${PN}
		doins share/test*
	fi
}
