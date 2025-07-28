# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="Python wrapper around rapidjson"
HOMEPAGE="
	https://github.com/python-rapidjson/python-rapidjson
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pysimdjson-7.0.1[${PYTHON_USEDEP}]
	>=dev-python/orjson-3.10.18[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.20.1[${PYTHON_USEDEP}]
	>=dev-python/ujson-5.10.0[${PYTHON_USEDEP}]
"
RESTRICT="test" # too much benchmarking
