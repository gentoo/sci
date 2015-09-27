# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Generation of arbitrary order instances of the Lagrange elements on lines, triangles, and tetrahedra"
HOMEPAGE="http://launchpad.net/fiat"
SRC_URI="https://launchpad.net/fiat/1.1.x/release-1.1/+download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-python/scientificpython[${PYTHON_USEDEP}]"
