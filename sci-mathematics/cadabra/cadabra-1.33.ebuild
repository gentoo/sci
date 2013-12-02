# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils texlive-common

DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://cadabra.phi-sci.com"
SRC_URI="http://cadabra.phi-sci.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples X test"

CDEPEND="
	sci-libs/modglue
	sci-mathematics/lie
	dev-libs/gmp[cxx]
	dev-libs/libpcre
	X? (
		x11-libs/gtk+:2
		dev-cpp/gtkmm:2.4
		dev-cpp/pangomm:1.4
		app-text/dvipng )"
DEPEND="${CDEPEND}
	doc? (
		app-doc/doxygen
		|| ( app-text/texlive-core dev-tex/pdftex ) )
	test? ( sys-process/time )"
RDEPEND="${CDEPEND}
	virtual/latex-base
	dev-texlive/texlive-latexrecommended"

src_prepare(){
	# fixing the flag mess
	epatch "${FILESDIR}/${PN}-1.33-FLAGS.patch"
}

src_configure(){
	econf $(use_enable X gui) \
		--disable-runtime-dependency-check
}

src_compile() {
	default

	if use doc; then
		cd "${S}/doc"
		emake
		cd doxygen/latex
		emake pdf
	fi
}

src_install() {
	# cadabra strip binaries unless you are on OS X. 
	# So faking it to avoid outright stripping.
	emake DESTDIR="${D}" DEVDESTDIR="${D}" MACTEST=1 install

	dodoc AUTHORS ChangeLog INSTALL

	if use doc;	then
		cd "${S}/doc/doxygen"
		dohtml html/*
		dodoc latex/*.pdf
	fi

	if use examples; then
		dodoc -r "${S}/examples/"
	fi

	rm -rf "${D}/usr/share/TeXmacs" || die
}

pkg_postinst() {
	etexmf-update
	elog "This version of the cadabra ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id= 194393"
}

pkg_postrm() {
	etexmf-update
}
