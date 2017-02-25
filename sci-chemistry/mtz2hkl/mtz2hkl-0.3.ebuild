# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Facilitate the transition from refmac5 refinement to shelxh or shelxl refinement"
HOMEPAGE="http://shelx.uni-ac.gwdg.de/~tg/research/programs/conv/mtz2x/mtz2hkl/"
SRC_URI="http://shelx.uni-ac.gwdg.de/~tg/research/programs/conv/mtz2x/${PN}/downloads/${PV}/${PN}_v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/libccp4"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	emake \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
}
