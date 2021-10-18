# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scaffold genome assemblies by Chromium/PacBio/Nanopore reads"
HOMEPAGE="https://github.com/bcgsc/LongStitch"
SRC_URI="https://github.com/bcgsc/LongStitch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="
	sci-biology/abyss
	sci-biology/tigmint
	sci-biology/LINKS
	sci-biology/samtools
"

S="${WORKDIR}"/LongStitch-"${PV}"

src_install(){
	dobin longstitch
	dodoc README.md LongStitch_overview.pdf
}
