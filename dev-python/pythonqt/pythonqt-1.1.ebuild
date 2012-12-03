# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2 python

MY_PN="PythonQt"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A dynamic Python binding for the Qt framework."
HOMEPAGE="http://pythonqt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${MY_PN}%20${PV}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples extensions test"

DEPEND="dev-lang/python
		x11-libs/qt-core
		x11-libs/qt-gui"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	sed -i \
		-e "s|unix:LIBS +=.*|unix:LIBS += $(python_get_library -l)|" \
		-e "s|unix:QMAKE_CXXFLAGS +=.*|unix:QMAKE_CXXFLAGS += -I$(python_get_includedir)|" \
		build/python.prf || die

	# Don't build examples and tests
	sed -i \
		-e 's/examples//' \
		-e 's/tests//' \
		${MY_PN}.pro || die

	if use !extensions; then
		sed -i 's/extensions//' ${MY_PN}.pro || die
	fi
}

src_configure() {
	eqmake4 "${S}" ./${MY_PN}.pro
}

src_install(){
	dodir /usr/include/${MY_PN}/{gui,wrapper}

	insinto /usr/include/${MY_PN}
	doins src/*.h

	insinto /usr/include/${MY_PN}/gui
	doins src/gui/*.h

	if use extensions; then
		insinto /usr/include/${MY_PN}/gui
		doins extensions/PythonQtGui/*.h
	fi

	insinto /usr/include/${MY_PN}/wrapper
	doins src/wrapper/*.h

	dolib.so lib/*.so*

	dodoc CHANGELOG.txt COPYING README
	dohtml doxygen/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
