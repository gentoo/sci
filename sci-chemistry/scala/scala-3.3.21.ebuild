# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/scala/scala-3.3.20.ebuild,v 1.6 2012/12/16 19:52:13 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2

DESCRIPTION="Scale together multiple observations of reflections"
HOMEPAGE="http://www.ccp4.ac.uk/dist/html/scala.html"
SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sci-libs/libccp4
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	cp "${FILESDIR}"/{configure.ac,Makefile.am} "${S}"
	autotools-utils_src_prepare
}

src_install() {
	dodoc ${PN}.doc
	dohtml ${PN}.html
	cd "${BUILD_DIR}"
	exeinto /usr/libexec/ccp4/bin/
	doexe ${PN}
	dosym ../libexec/ccp4/bin/${PN} /usr/bin/${PN}
}
