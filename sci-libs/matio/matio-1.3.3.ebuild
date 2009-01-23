# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils fortran autotools

DESCRIPTION="Library for reading and writing matlab files"
HOMEPAGE="http://sourceforge.net/projects/matio/"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples fortran"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
DEPEND="doc? ( app-doc/doxygen virtual/latex-base )"
RDEPEND=""

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

pkg_setup() {
	use fortran && fortran_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--enable-shared \
		--disable-test \
		$(use_enable fortran) \
		$(use_enable doc docs)
}

src_install() {
	emake DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		install || die "emake install failed"
	dodoc README ChangeLog
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doxygen/html
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins test/test*
		insinto /usr/share/${PN}
		doins share/test*
	fi
}
