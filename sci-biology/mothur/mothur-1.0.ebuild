# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.1 2008/08/26 16:33:07 weaver Exp $

inherit toolchain-funcs

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="http://schloss.micro.umass.edu/mothur/Main_Page"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	sed -i -e 's/CCP_OPTIONS =/CCP_OPTIONS = ${CXXFLAGS}/' \
		-e 's|CPP = /usr/bin/g++|CPP = '$(tc-getCXX)'|' "${S}/makefile" || die
}

src_install() {
	dobin mothur || die
}
