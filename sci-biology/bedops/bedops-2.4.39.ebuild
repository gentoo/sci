# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Manipulate BED file (alternative to bedtools)"
HOMEPAGE="http://bedops.readthedocs.io
	https://github.com/bedops/bedops"
SRC_URI="https://github.com/bedops/bedops/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	emake install
	dobin bin/*
	dodoc README.md
}
