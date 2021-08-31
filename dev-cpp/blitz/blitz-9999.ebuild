# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake git-r3 python-any-r1

DESCRIPTION="Multi-dimensional array library for C++"
HOMEPAGE="https://github.com/blitzpp/blitz"
EGIT_REPO_URI="https://github.com/blitzpp/blitz"

LICENSE="BSD LGPL-3+"
SLOT="0"
IUSE="boost doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen[dot] )
"
DEPEND="
	boost? ( dev-libs/boost:=[static-libs(-)] )
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
