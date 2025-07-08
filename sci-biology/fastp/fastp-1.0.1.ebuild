# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An ultra-fast all-in-one FASTQ preprocessor"
HOMEPAGE="https://github.com/OpenGene/fastp"
SRC_URI="https://github.com/OpenGene/fastp/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-arch/libdeflate
	dev-libs/isa-l"

src_install() {
	dodir /usr/bin
	emake PREFIX="${ED}"/usr install
}
