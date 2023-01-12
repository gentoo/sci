# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="An object oriented approach to visualization of 1D to 4D data"
HOMEPAGE="https://github.com/almarklein/visvis"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/imageio[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
