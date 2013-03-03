# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gnuplot/gnuplot-4.6_rc1.ebuild,v 1.7 2012/03/07 00:33:49 ulm Exp $

EAPI=5

inherit elisp-common multilib wxwidgets

DESCRIPTION="Command-line driven interactive plotting program"
HOMEPAGE="http://www.gnuplot.info/"

if [[ ${PV} = *9999 ]]; then
	inherit autotools
	#inherit cvs
	#ECVS_SERVER="gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot/gnuplot"
	#ECVS_MODULE="gnuplot"
	#ECVS_BRANCH="HEAD"
	#ECVS_USER="anonymous"
	#ECVS_CVS_OPTIONS="-dP"
	inherit git-2
	EGIT_REPO_URI="git://github.com/gnuplot/gnuplot.git"
	MY_P="${PN}"
else
	MY_P="${P/_/.}"
	SRC_URI="mirror://sourceforge/gnuplot/${MY_P}.tar.gz"
fi

LICENSE="gnuplot GPL-2 bitmap? ( free-noncomm )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bitmap cairo doc emacs examples +gd ggi latex lua qt4 readline svga thin-splines wxwidgets X xemacs"
REQUIRED_USE="?? ( emacs xemacs )"
RESTRICT="wxwidgets? ( test )"

RDEPEND="
	cairo? (
		x11-libs/cairo
		x11-libs/pango )
	emacs? ( virtual/emacs )
	gd? ( media-libs/gd[png] )
	ggi? ( media-libs/libggi )
	latex? (
		virtual/latex-base
		lua? (
			dev-tex/pgf
			>=dev-texlive/texlive-latexrecommended-2008-r2 ) )
	lua? ( dev-lang/lua )
	qt4? ( >=dev-qt/qtcore-4.5
		>=dev-qt/qtgui-4.5
		>=dev-qt/qtsvg-4.5 )
	readline? ( sys-libs/readline )
	svga? ( media-libs/svgalib )
	wxwidgets? (
		x11-libs/wxGTK:2.8[X]
		x11-libs/cairo
		x11-libs/pango
		x11-libs/gtk+:2 )
	X? ( x11-libs/libXaw )
	xemacs? (
		app-editors/xemacs
		app-xemacs/xemacs-base )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		app-text/ghostscript-gpl )
	xemacs? ( app-xemacs/texinfo )"

if [[ ${PV} = *9999 ]]; then
	# The live ebuild always needs an Emacs for building of gnuplot.texi
	DEPEND="${DEPEND}
	!emacs? ( !xemacs? ( || ( virtual/emacs app-xemacs/texinfo ) ) )"
fi

S="${WORKDIR}/${MY_P}"

GP_VERSION="${PV%.*}"
E_SITEFILE="50${PN}-gentoo.el"
TEXMF="${EPREFIX}/usr/share/texmf-site"

src_prepare() {
	if [[ ${PV} = *9999 ]]; then
		local dir
		for dir in config demo m4 term tutorial; do
			emake -C "$dir" -f Makefile.am.in Makefile.am
		done
		eautoreconf
	fi

	# Add special version identification as required by provision 2
	# of the gnuplot license
	sed -i -e "1s/.*/& (Gentoo revision ${PR})/" PATCHLEVEL || die
}

src_configure() {
	if ! use latex; then
		sed -i -e '/SUBDIRS/s/LaTeX//' share/Makefile.in || die
	fi

	if use wxwidgets; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
	fi

	local myconf
	myconf="${myconf} --with-lisp-files" #need to build info file
	myconf="${myconf} --with-lispdir=${EPREFIX}${SITELISP}/${PN}"
	myconf="${myconf} --without-pdf"
	myconf="${myconf} --enable-stats" #extra command save to be enabled
	myconf="${myconf} --with-texdir=${TEXMF}/tex/latex/${PN}"
	myconf="${myconf} $(use_with bitmap bitmap-terminals)"
	myconf="${myconf} $(use_with cairo)"
	myconf="${myconf} $(use_with doc tutorial)"
	myconf="${myconf} $(use_with gd)"
	myconf="${myconf} $(use_with ggi ggi ${EPREFIX}/usr/$(get_libdir))"
	myconf="${myconf} $(use_with ggi xmi ${EPREFIX}/usr/$(get_libdir))"
	myconf="${myconf} $(use_with lua)"
	myconf="${myconf} $(use_with svga linux-vga)"
	myconf="${myconf} $(use_enable thin-splines)"
	myconf="${myconf} $(use_enable wxwidgets)"
	myconf="${myconf} $(use_with X x)"
	myconf="${myconf} $(use_enable qt4 qt)"
	use readline \
		&& myconf="${myconf} --with-readline=gnu" \
		|| myconf="${myconf} --with-readline=builtin"

	local emacs=$(usev emacs || usev xemacs || echo no)
	if [[ ${PV} = *9999 && ${emacs} = no ]]; then
		# Live ebuild needs an Emacs to build gnuplot.texi
		if has_version virtual/emacs; then emacs=emacs
		elif has_version app-xemacs/texinfo; then emacs=xemacs; fi
	fi

	econf ${myconf} \
		DIST_CONTACT="http://bugs.gentoo.org/" \
		EMACS=${emacs}
}

src_compile() {
	# Prevent access violations, see bug 201871
	VARTEXFONTS="${T}/fonts"

	# We believe that the following line is no longer needed.
	# In case of problems file a bug report at bugs.gentoo.org.
	#addwrite /dev/svga:/dev/mouse:/dev/tts/0

	emake all info

	if use doc; then
		# Avoid sandbox violation in epstopdf/ghostscript
		addpredict /var/cache/fontconfig
		cd "${S}/docs"
		emake pdf
		cd "${S}/tutorial"
		emake pdf

		if use emacs; then
			cd "${S}/lisp"
			emake pdf
		fi
	fi
}

src_install () {
	emake DESTDIR="${D}" install install-info

	if use emacs; then
		# info-look* is included with >=emacs-21
		rm -f "${ED}${SITELISP}/${PN}"/info-look*

		# Gentoo emacs site-lisp configuration
		echo "(add-to-list 'load-path \"@SITELISP@\")" > ${E_SITEFILE}
		sed '/^;; move/,+3 d' "${S}"/lisp/dotemacs >> ${E_SITEFILE} || die
		elisp-site-file-install ${E_SITEFILE} || die
	fi

	cd "${S}"
	dodoc BUGS ChangeLog NEWS PGPKEYS PORTING README* TODO
	newdoc term/PostScript/README README-ps
	newdoc term/js/README README-js
	use lua && newdoc term/lua/README README-lua

	if use examples; then
		# Demo files
		insinto /usr/share/${PN}/${GP_VERSION}
		doins -r demo
		rm -f "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/Makefile*
		rm -f "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/binary*
	fi
	if use doc; then
		# Manual
		dodoc docs/gnuplot.pdf
		# Tutorial
		dodoc tutorial/{tutorial.dvi,tutorial.pdf}
		# FAQ
		dodoc FAQ.pdf
		# Documentation for making PostScript files
		docinto psdoc
		dodoc docs/psdoc/{*.doc,*.tex,*.ps,*.gpi,README}
	fi

	if use emacs; then
		docinto emacs
		dodoc lisp/ChangeLog lisp/README
		use doc && dodoc lisp/gpelcard.pdf
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && texmf-update

	elog "Gnuplot no longer links against pdflib, see the ChangeLog for"
	elog "details. You can use the \"pdfcairo\" terminal for PDF output."
	use cairo || elog "It is available with USE=\"cairo\"."

	if use svga; then
		echo
		elog "In order to enable ordinary users to use SVGA console graphics"
		elog "gnuplot needs to be set up as setuid root. Please note that"
		elog "this is usually considered to be a security hazard."
		elog "As root, manually \"chmod u+s /usr/bin/gnuplot\"."
	fi
	if use gd; then
		echo
		elog "For font support in png/jpeg/gif output, you may have to"
		elog "set the GDFONTPATH and GNUPLOT_DEFAULT_GDFONT environment"
		elog "variables. See the FAQ file in /usr/share/doc/${PF}/"
		elog "for more information."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use latex && texmf-update
}
