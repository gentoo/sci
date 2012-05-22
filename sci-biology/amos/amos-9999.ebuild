# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

[ "$PV" == "9999" ] && CVS=cvs

inherit eutils ${CVS}

DESCRIPTION="Genome assembly package live cvs sources"
HOMEPAGE="http://sourceforge.net/projects/amos"
ECVS_SERVER="amos.cvs.sourceforge.net:/cvsroot/amos"
ECVS_AUTH="pserver"
ECVS_MODULE="AMOS"
ECVS_BRANCH="HEAD"
ECVS_USER="anonymous"
ECVS_PASS=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="
	dev-libs/boost
	x11-libs/qt-qt3support"
RDEPEND="${DEPEND}
		dev-perl/DBI
		sci-biology/mummer"

S="${DISTDIR}"/cvs-src/AMOS/AMOS/

src_unpack() {
	ECVS_TOP_DIR="${DISTDIR}/cvs-src/${ECVS_MODULE}"
	cvs_src_unpack
}

src_prepare(){
	epatch "${FILESDIR}"/amos.m4.patch
}

src_configure() {
	./bootstrap || die
	#CFLAGS=$CFLAGS' -I/usr/include/qt4/Qt' CXXFLAGS=$CXXFLAGS' -I/usr/include/qt4/Qt' econf --enable-all --with-Qt-include-dir=/usr/include/qt4 --with-Qt-lib-dir=/usr/lib/qt4 --with-Qt-bin-dir=/usr/bin --with-Qt-lib=Qt3Support
	econf --enable-all
	einfo "No hawkeye and other Qt3-based apps installed, sorry, no qt3 anynore on Gentoo"
}

src_compile() {
	# TODO: force MAKEOPTS=-j1 because it seems -j6 is exploting some dependency issue in Makefiles
	MAKEOPTS=-j1 emake DESTDIR="${D}"
}
