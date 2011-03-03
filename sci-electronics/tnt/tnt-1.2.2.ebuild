# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base autotools eutils toolchain-funcs

DESCRIPTION="MoM 2.5 D stripline simulator"
SRC_URI="mirror://sourceforge/mmtl/${P}.tar.gz"
HOMEPAGE="http://mmtl.sourceforge.net/"
LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

SLOT="0"
IUSE="doc"

RDEPEND="
	dev-lang/tcl
	dev-tcltk/tcllib
	dev-tcltk/itcl
	dev-tcltk/bwidget
	sys-devel/gcc[fortran]
"
DEPEND="${RDEPEND}
	dev-texlive/texlive-latex
	dev-tex/latex2html
	media-gfx/imagemagick
"

PATCHES=( "${FILESDIR}/${P}"-{calc,bem-nmmtl,namespaces,f77,tkcon,docs,gui}.patch )

src_prepare() {
	base_src_prepare

	#adjust new document location in gui
	sed -i "s/package_name/${PF}/" gui/splash.tcl
	sed -i "s/package_name/${PF}/" gui/gui_help.tcl

	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS || die

	# tcl cannot handle the archives created by dodoc
	dohtml COPYING || die
	if use doc; then
				dodoc doc/*.pdf doc/*.png || die
				dohtml doc/user-guide/* || die
	fi

	# Install icon
	convert gui/logo.gif gui/tnt.png
	docinto "examples"
	dodoc examples/* || die "failed to install exampels"
	newicon gui/tnt.png tnt.png
	make_desktop_entry ${PN} "tnt" ${PN}
}

pkg_postinst() {
		elog "Warning: the sources are not under development anymore."
		elog "We made it compile, but users should check if the results make sense."
		elog "Examples are in the /usr/share/doc/tnt-1.2.2 folder."
}
