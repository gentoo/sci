# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library for reading and writing matlab .mat files"
HOMEPAGE="http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8187&objectType=file"
SLOT="0"
LICENSE="LGPL"
KEYWORDS="~x86"
IUSE="doc fortran"
SRC_URI="http://www.mathworks.com/matlabcentral/files/8187/${PN}.zip"
DEPEND="doc? ( app-doc/doxygen virtual/tetex )
	fortran? ( >=gcc-4.1 )"
S="${WORKDIR}/${PN}"

pkg_setup() {
	if use fortran ; then
		if ! built_with_use gcc fortran ; then
			einfo "Please re-emerge gcc with the USE flag fortran and try again"
			die
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/matio-1.1.4.patch"
}

src_compile() {
	aclocal
	automake || true
	econf --enable-shared $(use_enable fortran ) $(use_enable doc docs ) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install
	dodoc README ChangeLog
}
