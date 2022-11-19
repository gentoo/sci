# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="Generate LaTeX expression from Python code"
HOMEPAGE="https://github.com/google/latexify_py"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/dill[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

DOCS=( README.md docs )

python_test() {
	PYTHONPATH="${S}/src" epytest
}
