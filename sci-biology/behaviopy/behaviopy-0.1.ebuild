# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="https://github.com/TheChymera/behaviopy"
SRC_URI="https://github.com/TheChymera/behaviopy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="evaluation test"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/seaborn[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"

src_prepare() {
	if ! use evaluation; then
		rm behaviopy/evaluation.py || die
	fi
	default
}

python_test() {
	cd behaviopy/examples
	echo "backend : Agg" > matplotlibrc || die
	for i in *py; do
		echo "Executing $i"
		${EPYTHON} $i || die
	done
}
