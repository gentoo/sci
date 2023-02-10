# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Functions for 3D coordinate transformations"
HOMEPAGE="https://matthew-brett.github.io/transforms3d/"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/numpy-1.5.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
