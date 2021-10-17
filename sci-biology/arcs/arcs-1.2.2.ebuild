# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scaffold genome sequence assemblies by Chromium/PacBio/Naopore reads"
HOMEPAGE="https://github.com/bcgsc/arcs"
SRC_URI="https://github.com/bcgsc/arcs/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="minimal"

# TODO: fix this
# FileNotFoundError: [Errno 2] No such file or directory
# happens even with --install
RESTRICT="test"

RDEPEND="
	dev-libs/boost
	dev-cpp/sparsehash
	!minimal? (
		sci-biology/abyss
		sci-biology/tigmint
	)
"
# !minimal? ( sci-biology/LINKS )

src_install(){
	default
	insinto /usr/share/"${PN}"
	doins -r Examples
}
