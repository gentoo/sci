# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic fortran-2

DESCRIPTION="Collection of Python modules for statistical inference"
HOMEPAGE="http://inference.astro.cornell.edu/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-libs/scipy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/matplotlib[${PYTHON_USEDEP}]"

# buggy tests
RESTRICT="test"

S="${WORKDIR}"/${P}/package

pkg_setup() {
	fortran-2_pkg_setup
}

python_prepare_all() {
	# The usual numpy.distutils hacks when fortran is used
	append-ldflags -shared
	append-fflags -fPIC
	export NUMPY_FCONFIG="config_fc --noopt --noarch"
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile ${NUMPY_CONFIG}
}

python_test() {
	nosetests --verbose --verbosity=3 || die
}

python_install() {
	distutils-r1_python_install ${NUMPY_FCONFIG}
}
