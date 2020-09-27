# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="package for handling numpy arrays with units"
HOMEPAGE="https://github.com/yt-project/unyt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://raw.githubusercontent.com/yt-project/unyt/v${PV}/unyt/tests/data/old_json_registry.txt
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	mkdir -p "${S}"/unyt/tests/data || die
	mv "${DISTDIR}"/old_json_registry.txt "${S}"/unyt/tests/data/

	distutils-r1_python_prepare_all
}
