# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/muscle/muscle-3.7.ebuild,v 1.1 2008/03/21 21:23:44 dberkholz Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Analysis of repetitive DNA found in genome sequences"
HOMEPAGE="http://www.drive5.com/pilercr/"
SRC_URI="http://www.drive5.com/pilercr/pilercr.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gcc43.patch || die
}

src_compile() {
	emake GPP="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dobin pilercr || die
}
