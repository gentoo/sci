# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Instant inlining of C and C++ code in Python"
HOMEPAGE="https://bitbucket.org/fenics-project/instant/"
SRC_URI="https://bitbucket.org/fenics-project/instant/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/swig"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
