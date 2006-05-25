# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common

DESCRIPTION="Graphics Layout Engine - Professional Graphics Language"
HOMEPAGE="http://glx.sourceforge.net/"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86 -amd64"
IUSE="doc emacs X png tiff"
DEPEND="app-arch/unzip
	X? ( virtual/x11 )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	emacs? ( virtual/emacs )"

DOC_VER="4.0.9"
RESTRICT="nomirror"
SRC_URI="mirror://sourceforge/glx/gle_${PV}_src.zip
	doc? ( mirror://sourceforge/glx/gle-manual-${DOC_VER}.pdf
		   mirror://sourceforge/glx/GLEusersguide.pdf )
	emacs? ( http://glx.sourceforge.net/downloads/gle-emacs.el )"

src_unpack() {
	unpack ${A}
	# patch to allow parallelization and add the user CXXFLAGS
	epatch "${FILESDIR}"/${PF}-make.patch || die "epatch failed"
	cd "${S}"
	sed -e 's/^install: clean_install$/install:/' Makefile.gcc > Makefile
}

src_compile() {
	local myflags
	if use X
		then myflags="HAVE_LIBX11=1"
		else myflags="HAVE_LIBX11=0"
	fi
	if use png
		then myflags="${myflags} HAVE_LIBPNG=1"
		else myflags="${myflags} HAVE_LIBPNG=0"
	fi
	if use tiff
		then myflags="${myflags} HAVE_LIBTIFF=1"
		else myflags="${myflags} HAVE_LIBTIFF=0"
	fi
	export GLE_TOP=`pwd`
	emake EXTRA_CXXFLAGS="${CXXFLAGS}" \
		${myflags} || die "emake failed"
}

src_install() {
	make GLE_RPM_ROOT="${D}" install || die "make install failed"
	dodoc readme
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/gle-manual-${DOC_VER}.pdf \
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
	[ -f "${SITELISP}/site-gentoo.el" ] && elisp-site-regen
}
