# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common

DESCRIPTION="Graphics Layout Engine - Professional Graphics Language"
HOMEPAGE="http://glx.sourceforge.net/"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86"

MY_PN="GLE"
S="${WORKDIR}/gle4"

IUSE="X qt4 jpeg png tiff doc emacs"
DEPEND="app-arch/unzip
	X? ( || ( x11-libs/libX11 virtual/x11 ) )
	qt4? ( >=x11-libs/qt-4.1 )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	emacs? ( virtual/emacs )"

SRC_URI="mirror://sourceforge/glx/${MY_PN}-${PV}-src.zip
	doc? ( http://jeans.studentenweb.org/${MY_PN}-${PV}-pre1-manual.pdf
		   mirror://sourceforge/glx/GLEusersguide.pdf )
	emacs? ( http://glx.sourceforge.net/downloads/gle-emacs.el )"

#### delete the next line when moving this ebuild to the main tree!
RESTRICT="nomirror"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.patch" || die "epatch failed"
}

src_compile() {
	local QT
	if use qt4
	then QT='--with-qt=/usr'
	else QT='--without-qt'
	fi
	CXXFLAGS=${CXXFLAGS} econf \
		$(use_with X x ) \
		"${QT}" \
		$(use_with jpeg ) \
		$(use_with png ) \
		$(use_with tiff ) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README.txt
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}/${MY_PN}-${PV}-pre1-manual.pdf" \
			"${DISTDIR}/GLEusersguide.pdf"
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
	[ -f "${SITELISP}/site-gentoo.el" ] && elisp-site-regen
}
