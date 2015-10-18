# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Generation of arbitrary order instances of the Lagrange elements on lines, triangles, and tetrahedra"
HOMEPAGE="https://bitbucket.org/fenics-project/fiat"
SRC_URI="https://bitbucket.org/fenics-project/fiat/downloads/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/scientificpython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"
