# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit elisp-common

DESCRIPTION="Aldor - programming language with a two-level type system"
HOMEPAGE="http://www.aldor.org/"
LICENSE="aldor-public-license"
SLOT="0"
KEYWORDS="~x86 -*"
IUSE="doc emacs"
ALDOR="${PN}-linux-i386-glibc2.3-${PV}.bin"
DOC1="aldorug.pdf.gz"
DOC2="libaldor.pdf.gz"
DOC3="tutorial.pdf.gz"
URL4="ftp://ftp-sop.inria.fr/cafe/software/algebra"
DOC4="algebra.dvi.gz"
MODE_URL="http://www.risc.uni-linz.ac.at/people/hemmecke/aldor"
MODE="aldor.el.nw"
SRC_URI="${ALDOR}
	doc? ( http://www.aldor.org/docs/${DOC1}
		http://www.aldor.org/docs/${DOC2}
		http://www.aldor.org/docs/${DOC3}
		${URL4}/${DOC4} )
	emacs? ( ${MODE_URL}/${MODE} )"
RESTRICT="fetch"
RDEPEND="emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	doc? ( virtual/tetex )
	emacs? ( app-text/noweb )"
S="${WORKDIR}"

pkg_nofetch() {
	local PLURAL
	PLURAL=""
	einfo "Please visit ${HOMEPAGE} and read the license"
	einfo "If you accept it, download ${SRC_URI}"
	if use doc; then
		einfo "Also download ${DOC1}, ${DOC2}, ${DOC3}"
		einfo "Then go to ${URL4} and download ${DOC4}"
		PLURAL="s"
	fi
	if use emacs; then
		einfo "Then go to ${MODE_URL} and download ${MODE}"
		PLURAL="s"
	fi
	einfo "Then move the downloaded file${PLURAL} to ${DISTDIR}"
}

src_unpack() {
	if use emacs; then
		notangle "${DISTDIR}/aldor.el.nw" > aldor.el
		notangle -Rinit.el "${DISTDIR}/aldor.el.nw" | \
			sed -e '1s/^.*$/;; aldor mode/' > 64aldor-gentoo.el
		use doc && noweave "${DISTDIR}/aldor.el.nw" > aldor-mode.tex
	fi
}

src_compile() {
	if use doc; then
		dvipdfm algebra.dvi
		if use emacs; then
			pdflatex aldor-mode.tex
			pdflatex aldor-mode.tex
		fi
	fi
}

src_install() {
	local LINE="205"
	dodir /opt
	cd "${D}/opt"
	tail -n +"${LINE}" "${DISTDIR}/${SRC_URI}" | tar xzf -
	dodir "/opt/${PN}/${PV}"
	cd "${D}/opt/${PN}/linux/${PV}/bin"
	cd "${S}"
	cat > 64aldor <<EOF
ALDORROOT=/opt/${PN}/linux/${PV}
PATH=/opt/${PN}/linux/${PV}/bin
EOF
	doenvd 64aldor
	if use doc; then
		insinto "/usr/share/doc/aldor-${PV}"
		doins *.pdf
	fi
	if use emacs; then
		elisp-site-file-install aldor.el
		elisp-site-file-install 64aldor-gentoo.el
	fi
}

pkg_postinst() {
	ln -s "/opt/${PN}/linux/${PV}" "/opt/${PN}/${PV}/linux"
	ln -s `which ar` "/opt/${PN}/linux/${PV}/bin/uniar"
}

pkg_prerm() {
	rm -f "/opt/${PN}/${PV}/linux"
	rm -rf "/opt/${PN}/linux"
}
