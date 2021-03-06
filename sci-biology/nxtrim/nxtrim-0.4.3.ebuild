# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Trim Illumina TruSeq adapters and split reads by Nextera MatePair linker"
HOMEPAGE="https://github.com/sequencing/NxTrim"
SRC_URI="https://github.com/sequencing/NxTrim/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/NxTrim-${PV}"

src_install(){
	dobin nxtrim scripts/*
	einstalldocs
	dodoc -r docs/*
}
