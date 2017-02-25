# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2 toolchain-funcs

DESCRIPTION="MoM 2.5 D stripline simulator"
HOMEPAGE="http://mmtl.sourceforge.net/"
SRC_URI="mirror://sourceforge/mmtl/${P}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tcllib
	dev-tcltk/itcl
	dev-tcltk/bwidget"
DEPEND="${RDEPEND}
	dev-texlive/texlive-latex
	dev-tex/latex2html
	media-gfx/imagemagick"

PATCHES=( "${FILESDIR}/${P}"-{calc,bem-nmmtl,namespaces,f77,tkcon,docs,gui,autotools}.patch )

src_prepare() {
	#adjust new document location in gui
	sed -i "s/package_name/${PF}/" gui/splash.tcl || die
	sed -i "s/package_name/${PF}/" gui/gui_help.tcl || die

	autotools-utils_src_prepare
}

AUTOTOOLS_IN_SOURCE_BUILD=1

src_install () {
	# tcl cannot handle the archives created by dodoc
	if use doc; then
		DOCS=( doc/*.pdf doc/*.png )
		HTML_DOCS=( doc/user-guide/* )
	fi

	autotools-utils_src_install

	# Install icon
	convert gui/logo.gif gui/tnt.png
	docinto "examples"
	dodoc examples/*
	doicon gui/tnt.png
	make_desktop_entry ${PN} "tnt" ${PN}
}

pkg_postinst() {
	elog "Warning: the sources are not under development anymore."
	elog "We made it compile, but users should check if the results make sense."
	elog "Examples are in the /usr/share/doc/tnt-1.2.2 folder."
}
