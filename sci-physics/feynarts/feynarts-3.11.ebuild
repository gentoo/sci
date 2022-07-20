# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=FeynArts
MY_P=${MY_PN}-${PV}

DESCRIPTION="FeynArts renders Feynman diagrams and generates their topologies."
HOMEPAGE="http://feynarts.de"
SRC_URI="http://feynarts.de/${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-mathematics/mathematica
	"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	MMADIR=/usr/share/Mathematica/Applications
	dosym "${MY_P}" $MMADIR/"${MY_PN}"
	dodir $MMADIR/"${MY_P}"
	insinto $MMADIR
	doins -r "${S}"
}
