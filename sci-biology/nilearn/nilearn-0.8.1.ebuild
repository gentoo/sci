# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="http://nilearn.github.io/"
SRC_URI="https://github.com/nilearn/nilearn/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Tests attempt to download external data.
RESTRICT="test"

BDEPEND="
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	>=dev-python/joblib-0.12[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16[${PYTHON_USEDEP}]
	>=sci-libs/scikit-learn-0.21[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.2[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.5[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.24.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. epytest
}
