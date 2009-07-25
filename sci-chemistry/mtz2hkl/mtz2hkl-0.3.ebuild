# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base toolchain-funcs

DESCRIPTION="Intended to facilitate the transition from refmac5 refinement to shelxh or shelxl refinement"
HOMEPAGE="http://shelx.uni-ac.gwdg.de/~tg/mtz2x/mtz2hkl/mtz2hkl.php"
SRC_URI="http://shelx.uni-ac.gwdg.de/~tg/mtz2x/${PN}/downloads/${PV}/${PN}_v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/ccp4-libs"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	)

src_compile() {
	emake \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" || \
		die "compilation failed"
}

src_install() {
	dobin ${PN} || die "installation of ${PN} failed"
}
