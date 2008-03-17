# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common qt4

MY_P="GLE-${PV}"

DESCRIPTION="Layout engine for scripts and graphics"
HOMEPAGE="http://glx.sourceforge.net/"
SRC_URI="mirror://sourceforge/glx/${MY_P}-src.zip
	doc? ( http://jeans.studentenweb.org/${MY_P}-pre1-manual.pdf
		   mirror://sourceforge/glx/GLEusersguide.pdf )
	emacs? ( http://glx.sourceforge.net/downloads/gle-emacs.el )"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

IUSE="X qt4 jpeg png tiff doc emacs"

DEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11 )
	qt4? ( $(qt4_min_version 4.1) )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	emacs? ( virtual/emacs )
	app-arch/unzip"

RDEPEND="virtual/ghostscript
	virtual/latex-base
	sys-libs/ncurses
	X? ( x11-libs/libX11 )
	qt4? ( $(qt4_min_version 4.1) )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	emacs? ( virtual/emacs )"

#### delete the next line when moving this ebuild to the main tree!
RESTRICT="mirror"

S="${WORKDIR}/gle4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-configure.patch
}

src_compile() {
	local qtconf="--without-qt"
	use qt4 && qtconf="--with-qt=/usr"
	econf \
		$(use_with X x) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff) \
		${qtconf} || die "econf failed"

	# emake failed in src/gui (probably qmake stuff)
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README.txt

	if use qt4; then
		newicon src/gui/images/gle_icon.png gle.png
		make_desktop_entry qgle GLE gle
		newdoc src/gui/readme.txt gui_readme.txt
	fi

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${MY_P}-pre1-manual.pdf \
			"${DISTDIR}"/GLEusersguide.pdf
	fi

	if use emacs ; then
		elisp-site-file-install "${DISTDIR}"/gle-emacs.el gle-mode.el
		elisp-site-file-install "${FILESDIR}"/64gle-gentoo.el
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
