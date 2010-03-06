# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

WX_GTK_VER="2.8"

inherit autotools elisp-common multilib wxwidgets cvs

DESCRIPTION="Command-line driven interactive plotting program"
HOMEPAGE="http://www.gnuplot.info/"

ECVS_SERVER="gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot"
ECVS_MODULE="gnuplot"
ECVS_BRANCH="HEAD"
ECVS_USER="anonymous"
ECVS_CVS_OPTIONS="-dP"

LICENSE="gnuplot"
GP_VERSION="${PV:0:3}"
use multislot && SLOT="${PV:0:3}" || SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo doc emacs +gd ggi latex lua multislot pdf plotutils qt4 readline svga wxwidgets X xemacs"
RESTRICT="wxwidgets? ( test )"

RDEPEND="
	multislot? ( !!<=sci-visualization/gnuplot-4.2.6
		!!sci-visualization/gnuplot[-mutlislot]
		app-admin/eselect-gnuplot )
	xemacs? ( app-editors/xemacs app-xemacs/texinfo app-xemacs/xemacs-base )
	emacs? ( virtual/emacs !app-emacs/gnuplot-mode )
	pdf? ( media-libs/pdflib )
	lua? ( >=dev-lang/lua-5.1 )
	ggi? ( media-libs/libggi )
	gd? ( >=media-libs/gd-2[png] )
	doc? ( dev-tex/picins
		virtual/latex-base
		app-text/ghostscript-gpl )
	latex? ( virtual/latex-base
		lua? ( dev-tex/pgf
			>=dev-texlive/texlive-latexrecommended-2008-r2 ) )
	X? ( x11-libs/libXaw )
	svga? ( media-libs/svgalib )
	readline? ( >=sys-libs/readline-4.2 )
	plotutils? ( media-libs/plotutils )
	wxwidgets? ( x11-libs/wxGTK:2.8[X]
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
	use wxwidgets && need-wxwidgets unicode
	use wxwidgets && wxwidgets_pkg_setup
}

src_prepare() {
	local dir
	for dir in config demo m4 term tutorial; do
		emake -C "$dir" -f Makefile.am.in Makefile.am || \
		  die "make -f Makefile.am.in Makefile.am in $dir failed"
	done

	# Add Gentoo version identification since the licence requires it
	sed -i "s/$/ (Gentoo revision ${PR})/" PATCHLEVEL

	eautoreconf
}

src_configure() {
	local myconf="--enable-thin-splines"

	myconf="${myconf} $(use_with latex)"
	myconf="${myconf} $(use_with X x)"
	myconf="${myconf} $(use_with svga linux-vga)"
	myconf="${myconf} $(use_with gd)"
	myconf="${myconf} $(use_enable wxwidgets)"
	myconf="${myconf} $(use_with plotutils plot /usr/$(get_libdir))"
	myconf="${myconf} $(use_with pdf pdf /usr/$(get_libdir))"
	myconf="${myconf} $(use_with lua)"
	myconf="${myconf} $(use_with doc tutorial)"
	myconf="${myconf} $(use_enable qt4 qt)"

	use latex && myconf="${myconf} --with-texdir=${TEXMF}/${PN}/${GP_VERSION}"

	use ggi \
		&& myconf="${myconf} --with-ggi=/usr/$(get_libdir)
		--with-xmi=/usr/$(get_libdir)" \
		|| myconf="${myconf} --without-ggi"

	use readline \
		&& myconf="${myconf} --with-readline=gnu" \
		|| myconf="${myconf} --with-readline=builtin"

	myconf="${myconf} --without-lisp-files"
	use multislot && myconf="${myconf} --program-suffix='-${GP_VERSION}'"

	#we do the (x)emacs econf in src_install, also solves bug #194216
	EMACS=no \
	DIST_CONTACT="<http://bugs.gentoo.org>" \
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

	if use doc; then
		# Avoid sandbox violation in epstopdf/ghostscript
		addpredict /var/cache/fontconfig
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
	newdoc term/PostScript/README README-ps
	newdoc term/js/README README-js

	if use doc; then
		# Demo files
		insinto /usr/share/${PN}/${GP_VERSION}/demo
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

	use multislot && \
	  mv "${D}/usr/share/info/gnuplot.info" "${D}/usr/share/info/gnuplot-${GP_VERSION}.info"
}

pkg_postinst() {
	use multislot && eselect gnuplot update --if-unset --no-texupdate
	use emacs && elisp-site-regen
	use latex && texmf-update

	if use svga; then
		einfo "In order to enable ordinary users to use SVGA console graphics"
		einfo "gnuplot needs to be set up as setuid root.  Please note that"
		einfo "this is usually considered to be a security hazard."
		einfo "As root, manually \"chmod u+s /usr/bin/gnuplot\"."
	fi
	if use gd; then
		echo
		einfo "For font support in png/jpeg/gif output, you may have to"
		einfo "set the GDFONTPATH and GNUPLOT_DEFAULT_GDFONT environment"
		einfo "variables. See the FAQ file in /usr/share/doc/${PF}/"
		einfo "for more information."
	fi
}

pkg_postrm() {
	#in the case that we uninstall the last multislot version 
	if use multislot; then
		#rm symlinks
		has_version sci-visualization/gnuplot || eselect gnuplot update	--no-texupdate
	fi
	use emacs && elisp-site-regen
	use latex && texmf-update
}
