# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python package to access BIDS datasets"
HOMEPAGE="https://github.com/INCF/pybids"
SRC_URI="https://github.com/INCF/pybids/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="test? (	dev-python/mock[${PYTHON_USEDEP}] )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/num2words[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	sci-libs/bids-validator[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
