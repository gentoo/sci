# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} pypy{1_9,2_0} )

inherit distutils-r1

MY_PN="PuLP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Create MPS/LP files, call solvers, and present results"
HOMEPAGE="http://pulp-or.googlecode.com/"
SRC_URI="mirror://pypi/P/PuLP/${MY_P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE="examples"

DEPEND="dev-python/setuptools"
RDEPEND="
	dev-python/setuptools
	sci-libs/coinor-cbc
	>=sci-mathematics/glpk-4.35
	virtual/pyparsing"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	rm -rf ./src/pulp/solverdir/cbc* || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	if use examples; then
		insinto /usr/share/doc/"${PF}"/
		doins -r examples
	fi
}
