# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="nearest neighbor descent for approximate nearest neighbors"
HOMEPAGE="https://github.com/lmcinnes/pynndescent"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	dev-python/joblib[${PYTHON_USEDEP}]
	>=dev-python/numba-0.51.2[${PYTHON_USEDEP}]
	>=dev-python/llvmlite-0.34[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	<=sci-libs/scikit-learn-0.24.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests nose
