# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib qt4

SRC_URI="mirror://sourceforge/qwt/${P}.tar.bz2"
HOMEPAGE="http://qwt.sourceforge.net/"
DESCRIPTION="2D plotting library for Qt4"
LICENSE="qwt"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="5"
IUSE="doc svg"

DEPEND="$(qt4_min_version 4.2)"

src_compile () {
	# Configuration file
	qwtconfig="${S}"/qwtconfig.pri

	echo > ${qwtconfig} ""
	echo >> ${qwtconfig} "target.path = /usr/$(get_libdir)"
	echo >> ${qwtconfig} "headers.path = /usr/include/qwt5"
	echo >> ${qwtconfig} "doc.path = /usr/share/doc/${PF}"
	echo >> ${qwtconfig}
	echo >> ${qwtconfig} "CONFIG += qt warn_on thread"
	echo >> ${qwtconfig} "CONFIG += QwtDll QwtPlot QwtWidgets QwtDesigner"

	use svg && echo >> ${qwtconfig} "CONFIG += QwtSVGItem"
	use doc || echo >> src/src.pro "INSTALLS -= doc"

	# Generates top-level Makefile
	eqmake4

	# -j1 due to parallel build failures ( bug # 170625 )
	emake -j1 || die "emake failed"
}

src_install () {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc CHANGES README
}
