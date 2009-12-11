# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
WX_GTK_VER="2.8"

inherit autotools elisp-common eutils multilib wxwidgets cvs

DESCRIPTION="Command-line driven interactive plotting program"
HOMEPAGE="http://www.gnuplot.info/"

ECVS_SERVER="gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot"
ECVS_MODULE="gnuplot"
ECVS_USER="anonymous"
ECVS_CVS_OPTIONS="-dP"

LICENSE="gnuplot"
SLOT="0"
KEYWORDS="~x86"
IUSE="cairo doc emacs gd ggi latex lua pdf plotutils qt4 readline svga wxwidgets X xemacs"
RESTRICT="wxwidgets? ( test )"

RDEPEND="
	xemacs? ( app-editors/xemacs app-xemacs/texinfo app-xemacs/xemacs-base )
	emacs? ( virtual/emacs !app-emacs/gnuplot-mode )
	pdf? ( media-libs/pdflib )
	lua? ( >=dev-lang/lua-5.1 )
	ggi? ( media-libs/libggi )
	gd? ( >=media-libs/gd-2[png] )
	doc? ( dev-tex/picins
		virtual/latex-base
		virtual/ghostscript )
	latex? ( virtual/latex-base
		lua? ( dev-tex/pgf
			>=dev-texlive/texlive-latexrecommended-2008-r2 ) )
	X? ( x11-libs/libXaw )
	svga? ( media-libs/svgalib )
	readline? ( >=sys-libs/readline-4.2 )
	plotutils? ( media-libs/plotutils )
	wxwidgets? ( x11-libs/wxGTK:2.8
		>=x11-libs/cairo-0.9
		>=x11-libs/pango-1.10.3
		>=x11-libs/gtk+-2.8 )
	cairo? ( >=x11-libs/cairo-0.9
		>=x11-libs/pango-1.10.3
		>=x11-libs/gtk+-2.8 )
	qt4? ( >=x11-libs/qt-core-4.5
		>=x11-libs/qt-gui-4.5
		>=x11-libs/qt-svg-4.5 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${ECVS_MODULE}"
E_SITEFILE="50${PN}-gentoo.el"
TEXMF="/usr/share/texmf-site"

pkg_setup() {
	use wxwidgets && wxwidgets_pkg_setup
}

src_prepare() {
	local i
	epatch "${FILESDIR}"/${PN}-4.2.2-disable_texi_generation.patch #194216
	epatch "${FILESDIR}"/${PF}-app-defaults.patch #219323
	epatch "${FILESDIR}"/${PN}-4.2.3-disable-texhash.patch #201871
	# Add Gentoo version identification since the licence requires it
	epatch "${FILESDIR}"/${PF}-gentoo-version.patch

	for i in config demo m4 term tutorial; do
		cd $i
		emake -f Makefile.am.in Makefile.am || \
		  die "make -f Makefile.am.in Makefile.am in $i failed"
		cd ..
	done
	eautoreconf
}

src_configure() {
	# See bug #156427, kpsexpand is part of texlive-core
	if use latex ; then
		sed -i -e "s:\`kpsexpand.*\`:${TEXMF}/tex/latex/${PN}:" \
			share/LaTeX/Makefile.in || die "sed kpsexpand removed failed"
	else
		sed -i \
			-e '/^SUBDIRS/ s/LaTeX//' share/Makefile.in || \
			die "sed disable of LateX failed"
	fi

	local myconf="--with-gihdir=/usr/share/${PN}/gih --enable-thin-splines"

	myconf="${myconf} $(use_with X x)"
	myconf="${myconf} $(use_with svga linux-vga)"
	myconf="${myconf} $(use_with gd)"
	myconf="${myconf} $(use_enable wxwidgets)"
	myconf="${myconf} $(use_with plotutils plot /usr/$(get_libdir))"
	myconf="${myconf} $(use_with pdf pdf /usr/$(get_libdir))"
	myconf="${myconf} $(use_with lua)"
	myconf="${myconf} $(use_with doc tutorial)"
	myconf="${myconf} $(use_enable qt4 qt)"

	use ggi \
		&& myconf="${myconf} --with-ggi=/usr/$(get_libdir)
		--with-xmi=/usr/$(get_libdir)" \
		|| myconf="${myconf} --without-ggi"

	use readline \
		&& myconf="${myconf} --with-readline=gnu --enable-history-file" \
		|| myconf="${myconf} --with-readline=builtin"

	myconf="${myconf} --without-lisp-files"

	TEMACS=no
	use xemacs && TEMACS=xemacs
	use emacs && TEMACS=emacs

	CFLAGS="${CFLAGS} -DGENTOO_REVISION=\\\"${PR}\\\"" \
	EMACS=${TEMACS} \
		econf ${myconf} || die "econf failed"
}

src_compile() {
	# Prevent access violations, see bug 201871
	VARTEXFONTS="${T}/fonts"

	# This is a hack to avoid sandbox violations when using the Linux console.
	# Creating the DVI and PDF tutorials require /dev/svga to build the
	# example plots.
	addwrite /dev/svga:/dev/mouse:/dev/tts/0

	emake || die "emake failed"

	if use doc ; then
		cd docs
		emake pdf || die "emake pdf failed"
		cd ../tutorial
		emake pdf || die "emake pdf tutorial failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use emacs; then
		cd lisp
		einfo "Configuring gnuplot-mode for GNU Emacs..."
		EMACS="emacs" econf --with-lispdir="${SITELISP}/${PN}" || \
			die "econf emacs failed"
		emake DESTDIR="${D}" install || die "lisp install for emacs failed"
		emake clean
		cd ..

		# Gentoo emacs site-lisp configuration
		echo -e "\n;;; ${PN} site-lisp configuration\n" > ${E_SITEFILE}
		echo -e "(add-to-list 'load-path \"@SITELISP@\")\n" >> ${E_SITEFILE}
		sed '/^;; move/,+3 d' lisp/dotemacs >> ${E_SITEFILE}
		elisp-site-file-install ${E_SITEFILE}
	fi

	if use xemacs; then
		cd lisp
		einfo "Configuring gnuplot-mode for XEmacs..."
		EMACS="xemacs" \
			econf --with-lispdir="/usr/lib/xemacs/site-packages/${PN}" || \
				die "econf xemacs failed"
		emake DESTDIR="${D}" install || die "lisp install for xemacs failed"
		cd ..
	fi

	dodoc BUGS ChangeLog NEWS PATCHLEVEL PGPKEYS PORTING README* \
		TODO VERSION
	use lua && newdoc term/lua/README README-lua

	if use doc; then
		# Demo files
		insinto /usr/share/${PN}/demo
		doins demo/*
		# Manual
		insinto /usr/share/doc/${PF}/manual
		doins docs/gnuplot.pdf
		# Tutorial
		insinto /usr/share/doc/${PF}/tutorial
		doins tutorial/{tutorial.dvi,tutorial.pdf}
		# Documentation for making PostScript files
		insinto /usr/share/doc/${PF}/psdoc
		doins docs/psdoc/{*.doc,*.tex,*.ps,*.gpi,README}
	fi

	if ! use X; then
		# see bug 194527
		rm -rf "${D}/usr/$(get_libdir)/X11"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && texmf-update

	if use svga ; then
		einfo "In order to enable ordinary users to use SVGA console graphics"
		einfo "gnuplot needs to be set up as setuid root.  Please note that"
		einfo "this is usually considered to be a security hazard."
		einfo "As root, manually \"chmod u+s /usr/bin/gnuplot\"."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use latex && texmf-update
}
