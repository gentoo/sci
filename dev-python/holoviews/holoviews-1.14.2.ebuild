# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )

# HoloViews imports from "distutils" at runtime.
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Make data analysis and visualization seamless and simple"
HOMEPAGE="https://holoviews.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/param-1.9.3[${PYTHON_USEDEP}]
	>=dev-python/pyct-0.4.4[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/colorcet[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/panel-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyviz_comms-0.7.4[${PYTHON_USEDEP}]
"
