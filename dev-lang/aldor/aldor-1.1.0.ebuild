# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit elisp-common subversion

DESCRIPTION="Aldor - programming language with a two-level type system"
HOMEPAGE="http://www.aldor.org/"
LICENSE="aldor-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc emacs"
RDEPEND="emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	dev-util/byacc
	emacs? ( app-text/noweb doc? ( virtual/tetex ) )"
ESVN_REPO_URI="https://aquarium.aldor.csd.uwo.ca/svn/trunk"
SRC_URI="doc? ( http://aldor.org/docs/aldorug.pdf.gz
	http://aldor.org/docs/libaldor.pdf.gz
	http://aldor.org/docs/tutorial.pdf.gz
	ftp://ftp-sop.inria.fr/cafe/software/algebra/algebra.html.tar.gz )
	emacs? ( http://www.risc.uni-linz.ac.at/people/hemmecke/aldor/aldor.el.nw )"

src_compile() {
	if use emacs; then
		einfo "The aldor emacs mode"
		notangle "${DISTDIR}/aldor.el.nw" > aldor.el
		notangle -Rinit.el "${DISTDIR}/aldor.el.nw" | \
			sed -e '1s/^.*$/;; aldor mode/' > 64aldor-gentoo.el
		if use doc; then
			einfo "Documentation for the aldor emacs mode"
			noweave "${DISTDIR}/aldor.el.nw" > aldor-mode.tex
			pdflatex aldor-mode.tex
			pdflatex aldor-mode.tex
		fi
	fi
	if use doc; then
		einfo "Documentation"
		cp "${DISTDIR}/aldorug.pdf.gz" .
		cp "${DISTDIR}/libaldor.pdf.gz" .
		cp "${DISTDIR}/tutorial.pdf.gz" .
		gunzip aldorug.pdf.gz libaldor.pdf.gz tutorial.pdf.gz
		tar xzf "${DISTDIR}/algebra.html.tar.gz"
	fi
	cd "${PN}"
	einfo "Compiling aldor and its libraries"
	epatch "${FILESDIR}/${P}.patch"
	emake distrib
}

src_install() {
	cat > 64aldor <<EOF
ALDORROOT=/opt/${PN}/linux/${PV}
PATH=/opt/${PN}/linux/${PV}/bin
EOF
	doenvd 64aldor
	if use doc; then
		einfo "Installing the aldor documentation"
		insinto "/usr/share/doc/${P}"
		doins *.pdf
		doins -r algebra.html
	fi
	if use emacs; then
		einfo "Installing the aldor emacs mode"
		elisp-site-file-install aldor.el
		elisp-site-file-install 64aldor-gentoo.el
	fi
	einfo "Installing aldor and its libraries"
	cd "${PN}/install"
	dodir /opt
	cp -a "${PN}" "${D}opt/"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_prerm() {
	[ -f "${SITELISP}/site-gentoo.el" ] && elisp-site-regen
}
