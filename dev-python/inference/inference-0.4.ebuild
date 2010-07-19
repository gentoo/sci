# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils toolchain-funcs flag-o-matic

DESCRIPTION="Collection of Python modules for statistical inference"
HOMEPAGE="http://inference.astro.cornell.edu/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="mixed"

DEPEND="dev-python/scipy"
RDEPEND="${DEPEND}
	dev-python/matplotlib"

RESTRICT_PYTHON_ABIS="3.*"

# buggy tests
RESTRICT="test"

pkg_setup() {
	# The usual numpy.distutils hacks when fortran is used
	append-ldflags -shared
	[[ -z ${FC} ]] && export FC=$(tc-getFC)
	[[ -z ${F77} ]]	&& export F77=$(tc-getFC)
	export FFLAGS="${FFLAGS} -fPIC"
	export NUMPY_FCONFIG="config_fc --noopt --noarch"
}

src_compile() {
	distutils_src_compile ${NUMPY_CONFIG}
}

src_install() {
	distutils_src_install ${NUMPY_FCONFIG}
}
