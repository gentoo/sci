# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common

DESCRIPTION="scriptable vector graphics"
HOMEPAGE="http://asymptote.sourceforge.net"
SRC_URI="mirror://sourceforge/asymptote/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"

IUSE="boehm-gc doc fftw emacs gsl vim"

RDEPEND=">=sys-libs/readline-4.3-r5
	>=sys-libs/ncurses-5.4-r5
	dev-libs/libsigsegv
	boehm-gc? ( >=dev-libs/boehm-gc-6.7 )
	virtual/tetex
	fftw? ( >=sci-libs/fftw-3.0.1 )
	emacs? ( virtual/emacs )
	gsl? ( sci-libs/gsl )
	vim? ( app-editors/vim )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.5
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4a-r5
	doc? ( >=media-gfx/imagemagick-6.1.3.2
		virtual/ghostscript
		>=sys-apps/texinfo-4.7-r1 )"

pkg_setup() {
	# checking if Boehm garbage collector was compiled with c++ support
	if use boehm-gc ; then
		if ! built_with_use dev-libs/boehm-gc nocxx ; then
			einfo "dev-libs/boehm-gc has been compiled with nocxx use flag disabled"
		else
			echo
			eerror "You have to rebuild dev-libs/boehm-gc enabling c++ support"
			die
		fi
	fi
}

src_unpack() {
	unpack ${A}

	cd ${S}

	# fix latex dir
	einfo "Patching configure.ac"
	sed -i \
		-e "s:Datadir/doc/asymptote:Datadir/doc/${PF}:" \
		configure.ac || die "sed configure.ac failed"

	einfo "Building configure"
	WANT_AUTOCONF=2.5 autoconf

	# put examples dir in /usr/share/ instead of doc dir
	einfo "Patching Makefile.in"
	sed -i \
		-e 's:prefix = @prefix@:prefix = $(DESTDIR)@prefix@:' \
		-e 's:bindir = $(DESTDIR)@bindir@:bindir = @bindir@:' \
		-e 's:exampledir = $(docdir)/examples:exampledir = $(asydir)/examples:' \
		-e 's/install-asy install-man/install-asy install-doc/' \
		Makefile.in || die "sed Makefile.in failed"
	
	# 1) installation of asymptote.info in /usr/share/info
	# 2) remove asymptote.dvi generation
	# 3) remove *.eps image generation
	einfo "Patching doc/Makefile"
	sed -i \
		-e 's:$(prefix)/info:$(prefix)/share/info:' \
		-e 's@asymptote.info: asymptote.texi \$(FIGURES) \$(ASYFILES:.asy=.png)@asymptote.info: asymptote.texi@' \
		-e 's:asymptote.dvi asymptote.info:asymptote.info:' \
		-e 's@html:.\$(FIGURES) \$(ASYFILES:.asy=.eps) \$(ASYFILES:.asy=.png)@html: $(FIGURES) $(ASYFILES:.asy=.png)@' \
		doc/Makefile || die "sed doc/Makefile failed"

	if ! use doc ; then
		sed -i \
			-e 's/asy man/asy/' \
			Makefile.in || die "sed Makefile.in failed"

		sed -i \
			-e 's:asymptote.info html man:asymptote.info:' \
			-e 's@man:\tasymptote.pdf@man:@' \
			-e 's:${INSTALL} -p -m 644 asymptote.pdf $(docdir):#${INSTALL} -p -m 644 asymptote.pdf $(docdir):' \
			doc/Makefile || die "sed doc/Makefile failed"
	fi
}

src_compile() {
	for dir in `find /var/cache/fonts -type d`; do addwrite ${dir}; done
	econf $(use_enable boehm-gc gc system) || die "econf failed"

	# remove premature texhash command
	sed -i \
		-e "s/texhash/:/" \
		Makefile || die "sed Makefile failed"

	emake || die "emake failed"
}

src_install() {
	for dir in `find /var/cache/fonts -type d`; do addwrite ${dir}; done
	make DESTDIR=${D} install || die "make install failed"

	dodoc BUGS ChangeLog README ReleaseNotes TODO
	
	use doc && dohtml doc/asymptote/*

	if use emacs ; then
		elisp-site-file-install base/asy-mode.el
		elisp-site-file-install "${FILESDIR}"/64asy-gentoo.el
	fi

	if use vim ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins base/asy.vim
	fi
}

pkg_postinst() {
	einfo 'Updating TeX tree...\n'
	texconfig rehash &> /dev/null

	einfo 'Use the variable ASYMPTOTE_PSVIEWER to set the postscript viewer'
	einfo 'Use the variable ASYMPTOTE_PDFVIEWER to set the PDF viewer\n'

	use emacs && elisp-site-regen
}

pkg_postrm() {
	einfo 'Updating TeX tree...'
	texconfig rehash &> /dev/null

	[ -f "${SITELISP}"/site-gentoo.el ] && elisp-site-regen
}
