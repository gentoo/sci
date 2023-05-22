# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Uniform Manifold Approximation and Projection"
HOMEPAGE="https://umap-learn.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/numba-0.49[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
	>=dev-python/pynndescent-0.5[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=sci-libs/scikit-learn-0.22[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
