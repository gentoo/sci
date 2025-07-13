# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Uniform Manifold Approximation and Projection – fast non-linear dimension reduction"
HOMEPAGE="https://github.com/lmcinnes/umap"
SRC_URI="https://github.com/lmcinnes/umap/archive/release-${PV/_p/.post}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/umap-release-${PV/_p/.post}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numba[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pynndescent[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
