# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/muscle/muscle-3.7.ebuild,v 1.1 2008/03/21 21:23:44 dberkholz Exp $

inherit toolchain-funcs

DESCRIPTION="Pairwise Aligner for Long Sequences"
HOMEPAGE="http://www.drive5.com/pals/"
SRC_URI="http://www.drive5.com/pals/pals_source.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_compile() {
	emake GPP="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" || die
}

src_install() {
	DESTTREE="/usr" dobin pals
}
