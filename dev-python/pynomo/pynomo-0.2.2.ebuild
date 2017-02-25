# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="PyNomo"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PyNomo is a program to create nomographs (nomograms) using Python interpreter"
HOMEPAGE="http://pynomo.org/
	http://sourceforge.net/projects/pynomo/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="examples"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyx[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
DOCS=( AUTHORS.txt CHANGES.txt README.txt )

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
