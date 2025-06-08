# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Bidirectional communication for the HoloViz ecosystem"
HOMEPAGE="https://holoviz.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/param[${PYTHON_USEDEP}]"

# Tarballs do not include tests, reported upstream:
# https://github.com/holoviz/pyviz_comms/issues/104
#distutils_enable_tests pytest
