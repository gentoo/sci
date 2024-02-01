# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517="standalone"
inherit distutils-r1 pypi

DESCRIPTION="XGBoost Python Package"
HOMEPAGE="
	https://xgboost.readthedocs.io
	https://github.com/dmlc/xgboost/
"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
