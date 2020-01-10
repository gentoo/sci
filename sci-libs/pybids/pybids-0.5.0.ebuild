# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python package to access BIDS datasets"
HOMEPAGE="https://github.com/INCF/pybids"
SRC_URI="https://github.com/INCF/pybids/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/grabbit[${PYTHON_USEDEP}]
	dev-python/num2words[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"

# Tests are broken: https://github.com/INCF/pybids/issues/138
RESTRICT="test"
