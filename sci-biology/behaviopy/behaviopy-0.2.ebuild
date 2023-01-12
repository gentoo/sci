# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="https://github.com/TheChymera/behaviopy"
SRC_URI="https://github.com/TheChymera/behaviopy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="evaluation"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/seaborn[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

python_prepare_all() {
	if ! use evaluation; then
		rm behaviopy/evaluation.py || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	cd behaviopy/examples || die
	echo "backend : Agg" > matplotlibrc || die
	for i in *py; do
		echo "Executing $i"
		${EPYTHON} $i || die
	done
}
