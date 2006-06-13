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
SRC_URI="${PN}.zip"
DEPEND="doc? ( app-doc/doxygen )"
S="${WORKDIR}/${PN}"
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please visit"
	einfo "${HOMEPAGE}"
	einfo "download ${PN}.zip"
	einfo "and put it into ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/Makefile.in.patch"
}

src_compile() {
	econf --enable-shared $(use_enable fortran ) $(use_enable doc docs ) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	docdir="${D}usr/share/doc/${P}" make DESTDIR="${D}" install
	dodoc README ChangeLog
}
