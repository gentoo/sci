# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for working with the BIDS schema"
HOMEPAGE="https://github.com/bids-standard/bids-specification"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="render"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	render? (
		dev-python/markdown-it-py[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)
"
DEPEND=""

distutils_enable_tests pytest

src_prepare() {
	if ! use render; then
		rm "${S}/bidsschematools/render.py"
		rm "${S}/bidsschematools/tests/test_render.py"
	fi
	default
}
