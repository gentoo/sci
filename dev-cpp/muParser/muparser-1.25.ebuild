# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Library for parsing mathematical expressions"
HOMEPAGE="http://muparser.sourceforge.net/"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~x86"
IUSE="doc"
SRC_URI="mirror://sourceforge/muparser/${PN}.tar.gz"
DEPEND="doc? ( app-doc/doxygen )"
S="${WORKDIR}/muParser"

#### Remove the next line when moving this ebuild to the main tree!
RESTRICT="nomirror"

src_compile() {
	econf --disable-samples || die "econf failed"
	emake CXXFLAGS="${CXXFLAGS}" || die "emake failed"
	if use doc; then
		make documentation || die "make documentation failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins -r docs/html
	fi
}
