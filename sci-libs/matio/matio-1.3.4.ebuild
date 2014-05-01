# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils fortran-2

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

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--enable-shared \
		--disable-test \
		$(use_enable fortran) \
		$(use_enable doc docs) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog
	#if use doc; then
	#	insinto /usr/share/doc/${PF}
	#	doins -r doxygen/html || die
	#fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/test* || die
		insinto /usr/share/${PN}
		doins share/test* || die
	fi
}
