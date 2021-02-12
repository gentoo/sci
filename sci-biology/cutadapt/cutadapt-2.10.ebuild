# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Remove adapter sequences from high-throughput sequencing data"
HOMEPAGE="https://github.com/marcelm/cutadapt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/dnaio[${PYTHON_USEDEP}]
	dev-python/xopen[${PYTHON_USEDEP}]
"
RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/cython
		dev-python/pytest-mock
		dev-python/pytest-timeout
		dev-python/sphinx
		dev-python/sphinx-issues
	)
"

distutils_enable_tests pytest

# needs call to installed cutadapt executable
python_test() {
	distutils_install_for_testing
	pytest -vv || die "pytest failed with ${EPYTHON}"
}
