# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common autotools

DESCRIPTION="Free computer algebra environment, based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 AECA"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE="cmucl clisp sbcl tetex emacs auctex tcltk"

DEPEND="tetex? ( virtual/tetex )
	emacs? ( virtual/emacs )
	auctex? ( app-emacs/auctex )
	>=sys-apps/texinfo-4.3
	!clisp? ( !sbcl? ( !cmucl? ( >=dev-lisp/gcl-2.6.7 ) ) )
	cmucl? ( >=dev-lisp/cmucl-19a )
	clisp? ( >=dev-lisp/clisp-2.33.2-r1 )
	sbcl?  ( >=dev-lisp/sbcl-0.9.4 )"
# rlwrap is actually recommanded for clisp and sbcl 
RDEPEND=">=media-gfx/gnuplot-4.0
     cmucl? ( app-misc/rlwrap )
     sbcl?  ( app-misc/rlwrap )
     tcktk? ( >=dev-lang/tk-8.3.3 )"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/maxima-${PV}-unicode-fix.patch
	# replace ugly default ghostview with gv - could do kpdf/evince more general
	cd ${S}
	for gvfile in $(grep -rl *); do
		sed -i -e 's/ghostview/gv/g' ${gvfile}
	done
}

src_compile() {
	# automake version mismatch otherwise
	eautoreconf

	# remove xmaxima and rmaxima if not requested
	use tcltk  || sed -i -e '/^SUBDIRS/s/xmaxima//' interfaces/Makefile.in
	(! use sbcl && ! use cmucl) || sed -i -e '/^@WIN32_FALSE@bin_SCRIPTS/s/rmaxima//' src/Makefile.in

	local myconf=""
	if use cmucl || use clisp || use sbcl; then
		myconf="${myconf} $(use_enable cmucl)"
		myconf="${myconf} $(use_enable clisp)"
		myconf="${myconf} $(use_enable sbcl)"
	else
		if ! built_with_use dev-lisp/gcl ansi; then
			eerror "GCL must be installed with ANSI."
			eerror "Try USE=\"ansi\" emerge gcl"
			die "This package needs gcl with USE=ansi"
		fi
		myconf="${myconf} --enable-gcl"
	fi
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	
	if use emacs
	then
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el
	fi

	if use tetex
	then
		insinto /usr/share/texmf/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# Install documentation.
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS ChangeLog COPYING NEWS README*
	dodir /usr/share/doc
	dosym /usr/share/${PN}/${PV}/doc /usr/share/doc/${PF}
}

pkg_postinst() {
	if use emacs
	then
		einfo "Running elisp-site-regen...."
		elisp-site-regen
	fi
	if use tetex
	then
		einfo "Running mktexlsr to rebuild ls-R database...."
		mktexlsr
	fi
}

pkg_postrm() {
	if use emacs
	then
		einfo "Running elisp-site-regen...."
		elisp-site-regen
	fi
}
