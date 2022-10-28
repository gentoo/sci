# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="XGBoost Python Package"
HOMEPAGE="https://xgboost.readthedocs.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-fix-install.patch" )

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-fix-install.patch" )
