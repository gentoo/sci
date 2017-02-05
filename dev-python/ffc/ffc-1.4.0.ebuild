# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Compiler for multilinear forms by generating C or C++ code"
HOMEPAGE="https://bitbucket.org/fenics-project/ffc/"
SRC_URI="https://bitbucket.org/fenics-project/ffc/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!sci-mathematics/ufc
	~dev-python/ufl-${PV}[${PYTHON_USEDEP}]
	~dev-python/instant-${PV}[${PYTHON_USEDEP}]
	~dev-python/fiat-${PV}[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"
