# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library for reading and writing matlab .mat files"
HOMEPAGE="http://sourceforge.net/projects/matio/"
SLOT="0"
LICENSE="LGPL"
KEYWORDS="~x86"
IUSE="doc fortran"
RESTRICT="nomirror"
SRC_URI="mirror://sourceforge/matio/${P}.tar.gz"
DEPEND="doc? ( app-doc/doxygen virtual/tetex )
	fortran? ( >=gcc-4.1 )"

pkg_setup() {
	if use fortran ; then
		if ! built_with_use gcc fortran ; then
			einfo "Please re-emerge gcc with the USE flag fortran and try again"
			die
		fi
	fi
}

src_compile() {
	addwrite /var/cache/fonts
	addwrite /usr/share/texmf
	aclocal -I config
	automake
	econf --enable-shared --disable-test $(use_enable fortran ) $(use_enable doc docs ) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install
	dodoc README ChangeLog
}
