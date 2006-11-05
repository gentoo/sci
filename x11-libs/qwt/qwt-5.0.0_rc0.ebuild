# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib eutils

MY_PV="${PV/_/}"

SRC_URI="mirror://sourceforge/qwt/${PN}-${MY_PV}.tar.bz2"
HOMEPAGE="http://qwt.sourceforge.net/"
DESCRIPTION="2D plotting library for Qt4"
LICENSE="qwt"
KEYWORDS="~ppc64 ~x86"
SLOT="5"
IUSE="qt3 doc"

S="${WORKDIR}/${PN}-${MY_PV}"
QWTVER="5.0.0"

DEPEND="qt3? ( =x11-libs/qt-3* )
	!qt3? ( =x11-libs/qt-4* )
	>=sys-apps/sed-4"

src_unpack () {
	unpack ${A}
	cd ${S}
	find . -type f -name "*.pro" | while read file; do
		sed -e 's/.*no-exceptions.*//g' -i ${file}
		echo >> ${file} "QMAKE_CFLAGS_RELEASE += ${CFLAGS}"
		echo >> ${file} "QMAKE_CXXFLAGS_RELEASE += ${CXXFLAGS}"
	done
	find examples -type f -name "*.pro" | while read file; do
		echo >> ${file} "INCLUDEPATH += /usr/include/qwt"
	done
}

src_compile () {
	local QMAKE
	if use qt3; then
		QMAKE="${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake"
	else
		QMAKE="/usr/bin/qmake"
	fi
	${QMAKE} qwt.pro
	emake || die
	cd designer
	${QMAKE} qwtplugin.pro
	emake || die
}

src_install () {
	ls -l lib
	dolib lib/libqwt.so.${QWTVER}
	dosym libqwt.so.${QWTVER} /usr/$(get_libdir)/libqwt.so
	dosym libqwt.so.${QWTVER} /usr/$(get_libdir)/libqwt.so.${QWTVER/.*/}
	use doc && (dodir /usr/share/doc/${PF}
				cp -pPR examples ${D}/usr/share/doc/${PF}/
				dohtml doc/html/*)
	mkdir -p ${D}/usr/include/qwt5/
	install include/* ${D}/usr/include/qwt5/
	insinto /usr/$(get_libdir)/qt4/plugins/designer
	doins designer/plugins/designer/libqwt_designer_plugin.so
}
