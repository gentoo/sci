# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common autotools

DESCRIPTION="Free computer algebra environment, based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 AECA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cmucl clisp sbcl gcl tetex emacs auctex tcltk nls unicode"

DEPEND=">=sys-apps/texinfo-4.3
	tetex? ( virtual/tetex )
	emacs? ( virtual/emacs )
	auctex? ( app-emacs/auctex )
	!clisp? ( !sbcl? ( !cmucl? ( >=dev-lisp/gcl-2.6.7 ) ) )
	cmucl? ( >=dev-lisp/cmucl-19a )
	clisp? ( >=dev-lisp/clisp-2.33.2-r1 )
	gcl?   ( >=dev-lisp/gcl-2.6.7 )
	sbcl?  ( >=dev-lisp/sbcl-0.9.4 )"

# rlwrap is recommended for clisp and sbcl
RDEPEND=">=sci-visualization/gnuplot-4.0
	app-text/gv
	sbcl?  ( app-misc/rlwrap )
	cmucl? ( app-misc/rlwrap )
	tcltk? ( >=dev-lang/tk-8.3.3 )"

# chosen apps are hardcoded in maxima source:
# - ghostview for postscript (changed to gv)
# - acroread for pdf
# - xdvi for dvi. this could change, with pain.

src_unpack() {
	unpack ${A}
	# small patch for emaxima (from fedora)
	epatch ${FILESDIR}/${P}-emaxima.patch
	# patch to select firefox as def. browswer and add opera as choices
	epatch ${FILESDIR}/${P}-default-browser.patch
	# replace ugly ghostview with gv
	for psfile in $(grep -rl ghostview ${P}/*); do
		sed -i -e 's/ghostview/gv/g' ${psfile}
	done
}

src_compile() {
	# automake version mismatch otherwise (sbcl only)
	use sbcl && eautoreconf

	# remove rmaxima if neither cmucl nor sbcl
	if ! use sbcl && ! use cmucl ; then
		sed -i -e '/^@WIN32_FALSE@bin_SCRIPTS/s/rmaxima//' src/Makefile.in
	fi

	# remove xmaxima if no tk
	local myconf=""
	if use tcltk; then
		myconf="${myconf} --with-wish=wish"
	else
		myconf="${myconf} --with-wish=none"
		sed -i -e '/^SUBDIRS/s/xmaxima//' interfaces/Makefile.in
	fi

	# enable gcl if no other lisp selected
	if use gcl || (! use cmucl && ! use clisp && ! use sbcl ); then
		if ! built_with_use dev-lisp/gcl ansi; then
			eerror "GCL must be installed with ANSI."
			eerror "Try USE=\"ansi\" emerge gcl"
			die "This package needs gcl with USE=ansi"
		fi
		myconf="${myconf} --enable-gcl"
	fi

	# enable existing translated doc
	if use nls; then
		for lang in es pt; do
			if use linguas_${lang}; then
				myconf="${myconf} --enable-lang-${lang}"
				use unicode && myconf="${myconf} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf \
		$(use_enable cmucl) \
		$(use_enable clisp) \
		$(use_enable sbcl) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	use tcltk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png

	if use emacs; then
		sed -e "s/PV/${PV}/" "${FILESDIR}"/50maxima-gentoo.el > 50maxima-gentoo.el
		elisp-site-file-install 50maxima-gentoo.el
	fi

	if use tetex; then
		insinto /usr/share/texmf/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# install documentation
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS ChangeLog COPYING NEWS README*
	dodir /usr/share/doc
	dosym /usr/share/${PN}/${PV}/doc /usr/share/doc/${PF}
}

pkg_preinst() {
	# do not gunzip the info files in certain cases of lisp
	if use cmucl || use clisp || use sbcl; then
		for infofile in $(ls ${D}/usr/share/info/*.gz); do
			gunzip ${infofile}
		done
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use tetex && mktexlsr
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
