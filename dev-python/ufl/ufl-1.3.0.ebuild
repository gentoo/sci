# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Domain specific language for declaration of FE discretizations of variational forms"
HOMEPAGE="https://bitbucket.org/fenics-project/ufl/"
SRC_URI="https://bitbucket.org/fenics-project/ufl/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scipy"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	scipy? ( sci-libs/scipy[${PYTHON_USEDEP}] )
	"
