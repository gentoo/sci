# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for distributed just-in-time shared library building"
HOMEPAGE="https://bitbucket.org/fenics-project/dijitso/"
SRC_URI="https://bitbucket.org/fenics-project/dijitso/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/mpi4py"
