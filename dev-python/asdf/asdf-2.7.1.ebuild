# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python library for the Advanced Scientific Data Format"
HOMEPAGE="
	https://pypi.org/project/asdf/
	https://github.com/asdf-format/asdf
	https://asdf.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.10[${PYTHON_USEDEP}]
	>=dev-python/pyrsistent-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/semantic_version-2.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs
