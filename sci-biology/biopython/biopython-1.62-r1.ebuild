# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/biopython/biopython-1.62.ebuild,v 1.1 2013/09/17 16:07:56 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 eutils

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="http://www.biopython.org/ http://pypi.python.org/pypi/biopython/"
SRC_URI="http://www.biopython.org/DIST/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="mysql postgres"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	media-gfx/pydot[${PYTHON_USEDEP}]
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	postgres? ( dev-python/psycopg[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	sys-devel/flex"

DOCS=( CONTRIB DEPRECATED NEWS README Doc/. )

src_prepare() {
	distutils-r1_src_prepare
	epatch "${FILESDIR}/${PN}-1.62-SffIO.patch"
}

python_test() {
	cd Tests || die
	${PYTHON} run_tests.py || die
}

python_install_all() {
	distutils-r1_python_install_all

	dodir /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED}"/usr/share/${PN} || die
}
