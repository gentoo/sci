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
	SRC_URI="https://github.com/arrayfire/arrayfire-python/archive/${PV}.tar.gz -> ${P}.tar.gz"
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

python_test() {
	${EPYTHON} -m arrayfire.tests || \
		die "tests failed with ${EPYTHON}"
}
