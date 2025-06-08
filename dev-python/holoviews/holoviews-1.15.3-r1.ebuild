# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

# HoloViews imports from "distutils" at runtime.
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 pypi

DESCRIPTION="Make data analysis and visualization seamless and simple"
HOMEPAGE="https://holoviews.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# Reported upstream:
# https://github.com/holoviz/holoviews/issues/5592
RESTRICT="test"

DEPEND="
	>=dev-python/param-1.9.3[${PYTHON_USEDEP}]
	>=dev-python/pyct-0.4.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/bokeh[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nbconvert[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/plotly[${PYTHON_USEDEP}]
		sci-visualization/dash[${PYTHON_USEDEP}]
	)
"
RDEPEND="${DEPEND}
	dev-python/colorcet[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/panel-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyviz_comms-0.7.4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
