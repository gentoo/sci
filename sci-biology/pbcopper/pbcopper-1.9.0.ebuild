# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Core C++ library for data structures, algorithms, and utilities"
HOMEPAGE="https://github.com/PacificBiosciences/pbcopper"
SRC_URI="https://github.com/PacificBiosciences/pbcopper/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="blasr"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	virtual/pkgconfig
	>=dev-lang/swig-3.0.5
	>=dev-cpp/gtest-1.8.1
"

DEPEND="
	>=sci-libs/htslib-1.3.1:=
	>=dev-libs/boost-1.55:=[threads(-)]
"
RDEPEND="${DEPEND}"
