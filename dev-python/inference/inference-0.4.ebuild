# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils fortran-2 toolchain-funcs flag-o-matic

DESCRIPTION="Collection of Python modules for statistical inference"
HOMEPAGE="http://inference.astro.cornell.edu/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/scipy"
RDEPEND="${DEPEND}
	dev-python/matplotlib"

RESTRICT_PYTHON_ABIS="3.*"

# buggy tests
RESTRICT="test"

pkg_setup() {
	fortran-2_pkg_setup
	# The usual numpy.distutils hacks when fortran is used
	append-ldflags -shared
	append-fflags -fPIC
	export NUMPY_FCONFIG="config_fc --noopt --noarch"
}

src_compile() {
	distutils_src_compile ${NUMPY_CONFIG}
}

src_install() {
	distutils_src_install ${NUMPY_FCONFIG}
}
