# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic fortran-2 mercurial toolchain-funcs

IUSE=""
SRC_URI=""
EHG_REPO_URI="http://hg.code.sf.net/p/pesto/code-1"

DESCRIPTION="Potential Energy Surface Tools"
HOMEPAGE="http://sourceforge.net/projects/pesto/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

RDEPEND="virtual/blas
	virtual/lapack
	dev-python/numpy[${PYTHON_USEDEP},lapack]
	sci-libs/k3match[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

DOCS=( README.txt )
EXAMPLES=( examples )
DISTUTILS_IN_SOURCE_BUILD=1

src_configure() {
	append-fflags "-shared -fPIC"
	append-ldflags "-shared"
	distutils-r1_src_configure
}
