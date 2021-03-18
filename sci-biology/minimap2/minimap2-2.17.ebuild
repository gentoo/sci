# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="splice-aware sequence aligner"
HOMEPAGE="https://github.com/lh3/minimap2"
SRC_URI="https://github.com/lh3/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install(){
	dobin "${PN}"
}
