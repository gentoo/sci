# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="Manipulate BED file (alternative to bedtools)"
HOMEPAGE="http://bedops.readthedocs.io
	https://github.com/bedops/bedops"
SRC_URI="https://github.com/bedops/bedops/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	default
	local PATCHES=("${FILESDIR}"/${P}-respect-cxxflags.patch)
	epatch ${PATCHES[@]}
}
