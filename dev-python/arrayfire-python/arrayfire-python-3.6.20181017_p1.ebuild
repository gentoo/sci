# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python bindings for ArrayFire"
HOMEPAGE="http://www.arrayfire.com"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/arrayfire/arrayfire-python"
else
	COMMIT=534b8c2ab4db5b08347f4d3d2f86a58ba8fcfdb6
	SRC_URI="https://github.com/arrayfire/arrayfire-python/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/arrayfire
"
DEPEND="${RDEPEND}"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${P}-skip_tests.patch )

python_test() {
	${EPYTHON} -m tests || \
		die "tests failed with ${EPYTHON}"
}
