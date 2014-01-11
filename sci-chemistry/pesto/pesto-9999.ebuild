# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 fortran-2 mercurial toolchain-funcs

IUSE=""
SRC_URI=""
EHG_REPO_URI="http://hg.code.sf.net/p/pesto/code-1"

DESCRIPTION="Potential Energy Surface Tools"
HOMEPAGE="http://sourceforge.net/projects/pesto/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

RDEPEND="virtual/blas
	virtual/lapack"

DEPEND="${RDEPEND}"

DOCS=( README.txt )
EXAMPLES=( examples )
DISTUTILS_IN_SOURCE_BUILD=1
