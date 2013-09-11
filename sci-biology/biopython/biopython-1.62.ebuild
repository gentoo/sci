# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/biopython/biopython-1.61.ebuild,v 1.3 2013/07/02 12:47:34 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Python modules for computational molecular biology"
HOMEPAGE="http://www.biopython.org/ http://pypi.python.org/pypi/biopython/"
SRC_URI="http://biopython.org/DIST/biopython-1.62.tar.gz"

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

DOCS=( CONTRIB DEPRECATED NEWS README )
S="${WORKDIR}/biopython-1.62"

python_test() {
	cd Tests
	${PYTHON} run_tests.py
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/doc/${PF}
	doins -r Doc/*
	insinto /usr/share/${PN}
	cp -r --preserve=mode Scripts Tests "${ED}"/usr/share/${PN} || die
}
