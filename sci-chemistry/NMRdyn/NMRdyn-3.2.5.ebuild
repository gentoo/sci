# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic qmake-utils toolchain-funcs

MY_P="${PN}_${PV}"

DESCRIPTION="NMR relaxation studies of protein association"
HOMEPAGE="http://sourceforge.net/projects/nmrdyn/"
SRC_URI="${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+qt4"

RDEPEND="
	sci-libs/gsl
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

RESTRICT="mirror fetch"

S="${WORKDIR}"/${MY_P}

pkg_nofetch() {
	elog "Please contact the authors and get ${A}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-redefinition.patch
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags gsl)"
	if use qt4; then
		cd src/NMRdynGUI || die
		cat >> NMRdynGUI.pro <<- EOF
		INCLUDEPATH += "${S}"/src/algorithm/src
		LIBS += $($(tc-getPKG_CONFIG) --libs gsl)
		MOC_DIR = moc/
		OBJECTS += ../objects/*.o
		EOF
	fi
}

src_configure() {
	if use qt4; then
		cd src/NMRdynGUI || die
		eqmake4 NMRdynGUI.pro
	fi
}

src_compile() {
	emake \
		-C src/algorithm \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LIBS="$($(tc-getPKG_CONFIG) --libs gsl)"

	if use qt4; then
		cd src/NMRdynGUI || die
		default
	fi
}

src_install() {
	dobin ${PN} r1r2
	use qt4 && dobin src/NMRdynGUI/${PN}GUI
	dodoc HISTORY README_LINUX.txt NMRdynManual.doc README_gridsearch.txt
}
