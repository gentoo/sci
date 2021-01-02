# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python module for distributed just-in-time shared library building"
HOMEPAGE="https://bitbucket.org/fenics-project/dijitso/"
SRC_URI="https://bitbucket.org/fenics-project/dijitso/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/mpi4py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
# TODO: fix this, seems to require self
#distutils_enable_sphinx doc/sphinx/source
distutils_enable_tests --install pytest
