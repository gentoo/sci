# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="The PacBio long read aligner"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
SRC_URI="https://github.com/PacificBiosciences/blasr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="blasr"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"
DEPEND="
	sci-biology/libblasr
	dev-libs/boost:=
"
RDEPEND="${DEPEND}"
