# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517="standalone"
inherit distutils-r1 pypi

DESCRIPTION="Scalable, Portable and Distributed Gradient Boosting Library."
HOMEPAGE="
	https://xgboost.readthedocs.io
	https://github.com/dmlc/xgboost/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
