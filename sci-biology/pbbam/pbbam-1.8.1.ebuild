# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="PacBio modified BAM file format"
HOMEPAGE="https://pbbam.readthedocs.io/en/latest/index.html"
SRC_URI="https://github.com/PacificBiosciences/pbbam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="blasr"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	virtual/pkgconfig
	>=dev-cpp/gtest-1.8.1
	>=dev-lang/swig-3.0.5
"
DEPEND="
	sci-biology/pbcopper
	sci-biology/samtools:0
	>=sci-libs/htslib-1.3.1:=
	>=dev-libs/boost-1.55:=
"
RDEPEND="${DEPEND}"
