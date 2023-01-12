# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit cmake python-any-r1

COMMIT="39f885951a9b8b11f931f917935a16066a945056"
DESCRIPTION="Multi-dimensional array library for C++"
HOMEPAGE="https://github.com/blitzpp/blitz"
SRC_URI="https://github.com/blitzpp/blitz/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="boost doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen[dot] )
"
DEPEND="
	boost? ( dev-libs/boost:= )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC=$(usex doc)
		-DBUILD_TESTING=$(usex test)
		-DENABLE_SERIALISATION=$(usex boost)
	)
	use doc && mycmakeargs+=( -DDISABLE_REFMAN_PDF=ON )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build blitz-doc
	use test && cmake_build testsuite benchmark examples
}

src_install() {
	cmake_src_install
	if use doc ; then
		find "${D}" -type f \( -name "*.md5" -o -name "*.map" \) -delete || die
	fi
}
