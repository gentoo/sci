# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
CMAKE_MAKEFILE_GENERATOR=emake

DESCRIPTION="multi-dimensional array library for C++"
HOMEPAGE="https://github.com/blitzpp/blitz"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/blitzpp/blitz"
else
	COMMIT=39f885951a9b8b11f931f917935a16066a945056
	SRC_URI="https://github.com/blitzpp/blitz/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="BSD LGPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	if use test; then
		cmake_build check-testsuite check-benchmarks check-examples
	else
		cmake build
	fi
}
