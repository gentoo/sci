# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Distances and representations of persistence diagrams"
HOMEPAGE="https://persim.scikit-tda.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	dev-python/hopcroftkarp[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Reported upsream:
	# https://github.com/scikit-tda/persim/issues/64
	test/test_persim.py::test_integer_diagrams
	test/test_persim.py::TestEmpty::test_empyt_diagram_list
	test/test_persim.py::TestTransforms::test_lists_of_lists
	test/test_persim.py::TestTransforms::test_n_pixels
	test/test_persim.py::TestTransforms::test_multiple_diagrams
)
