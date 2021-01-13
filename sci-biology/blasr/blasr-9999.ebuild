# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="The PacBio long read aligner"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
EGIT_REPO_URI="https://github.com/PacificBiosciences/blasr.git"
#SRC_URI="https://github.com/PacificBiosciences/blasr/tarball/${PV} -> ${P}.tar.gz"

LICENSE="blasr"
SLOT="0"
KEYWORDS=""

BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"
DEPEND="
	sci-biology/pbbam
	sci-biology/libblasr
	dev-libs/boost:=[threads]
"
RDEPEND="${DEPEND}"
