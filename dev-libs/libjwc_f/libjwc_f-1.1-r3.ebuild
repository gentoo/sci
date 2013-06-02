# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libjwc_f/libjwc_f-1.1-r2.ebuild,v 1.5 2012/10/19 10:32:13 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils fortran-2 toolchain-funcs

PATCH="612"

DESCRIPTION="Additional fortran library for ccp4"
HOMEPAGE="http://www.ccp4.ac.uk/main.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/jwc/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="static-libs"

RDEPEND="
	dev-libs/libjwc_c
	sci-libs/libccp4
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PATCH}-gentoo.patch
	"${FILESDIR}"/${P}-else.patch
)

src_prepare() {
	rm missing || die
	echo "libjwc_f_la_LIBADD = -ljwc_c $($(tc-getPKG_CONFIG --libs libccp4f))" >> Makefile.am || die
	autotools-utils_src_prepare
}

src_install() {
	HTML_DOCS=( doc/. )
	autotools-utils_src_install
}
