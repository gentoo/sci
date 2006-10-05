# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fortran

DESCRIPTION="Library for reading and writing matlab .mat files"
HOMEPAGE="http://sourceforge.net/projects/matio/"
SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86"
IUSE="doc fortran"
SRC_URI="mirror://sourceforge/matio/${P}.tar.gz"
DEPEND="doc? ( app-doc/doxygen virtual/tetex )"
FORTRAN="gfortran"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="nomirror"

pkg_setup() {
	use fortran && fortran_pkg_setup
}

src_compile() {
	addwrite /var/cache/fonts
	addwrite /usr/share/texmf
	econf --enable-shared \
		--disable-test \
		$(use_enable fortran ) \
		$(use_enable doc docs ) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README ChangeLog
}
