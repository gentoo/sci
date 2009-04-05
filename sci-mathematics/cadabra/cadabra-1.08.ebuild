# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

EAPI=2
DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://www.aei.mpg.de/~peekas/cadabra"
SRC_URI="http://www.aei.mpg.de/~peekas/cadabra/${P}.tar.gz"
#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples X"
DEPEND="sci-libs/modglue
	sci-mathematics/lie
	dev-libs/gmp
	dev-libs/libpcre
	X? ( >=x11-libs/gtk+-2.0
	    >=dev-cpp/gtkmm-2.4
	    app-text/dvipng )"
RDEPEND="${DEPEND}
	virtual/latex-base
	dev-tex/mh"

src_prepare() {
#	fix src/makefile.in
	epatch "${FILESDIR}/${P}-as-needed.patch"
}


src_compile() {
	local myconf=""

	myconf="${myconf} `use enable X gui`"

	econf ${myconf} || die
	emake || die

	if ( use doc )
	then
		cd "${S}/doc"
		make
		cd doxygen/latex
		make pdf
	fi
}

src_install() {
	einstall DESTDIR="${D}" DEVDESTDIR="${D}" || die

	dodoc AUTHORS ChangeLog INSTALL

	use examples &&	cp -R "${S}/examples" "${D}/usr/share/doc/${PF}"

	if ( use doc )
		then
		cd "${S}/doc/doxygen"
		dohtml html/*
		cp latex/*.pdf "${D}/usr/share/doc/${PF}"
	fi

	rm -rf "${D}/usr/share/TeXmacs"

}

pkg_postinst() {
	/usr/sbin/texmf-update
	elog "This version of the cadabra ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id= 194393"
}

pkg_postrm()
{
	/usr/sbin/texmf-update
}
