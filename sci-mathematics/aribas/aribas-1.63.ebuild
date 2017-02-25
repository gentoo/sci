# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp-common versionator

DESCRIPTION="Interpreter for big integer and multi-precision floating point arithmetic"
HOMEPAGE="http://www.mathematik.uni-muenchen.de/~forster/sw/${PN}.html"
SRC_URI="ftp://ftp.mathematik.uni-muenchen.de/pub/forster/${PN}/UNIX_LINUX/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc emacs examples"

RDEPEND="emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}"

SITEFILE=64${PN}-gentoo.el
CH_PV=$(delete_all_version_separators)

src_prepare() {
	# Linux x86 assembly piece
	if use x86; then
		mv LINUX/arito386.S . || die
		mv LINUX/Makefile.linux Makefile || die
	fi

	# removing strip
	sed -e '/^	strip \$(PROGRAM)$/d' -i Makefile || die "sed failed"
}

src_compile() {
	cd src || die
	if use x86; then
		emake CFLAGS="-DLiNUX -DPROTO ${CFLAGS}"
	else
		emake CC=gcc CFLAGS="-DUNiX -DPROTO ${CFLAGS}"
	fi

	if use emacs; then
		cd EL || doe
		elisp-compile *.el
	fi
}

src_install() {
	dobin src/${PN}
	doman doc/*.1
	dodoc CHANGES${CH_PV}.txt

	if use doc; then
		dodoc doc/${PN}.doc doc/${PN}.tut
	fi

	if use examples; then
		insinto /usr/share/${P}
		doins -r examples
	fi

	if use emacs; then
		cd src/EL || die
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
		newdoc EL/README README.emacs
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
