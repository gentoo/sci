# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A Python kernel for Jupyter/IPython"
HOMEPAGE="https://github.com/Calysto/metakernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-python/metakernel-0.11.0[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

python_install_all() {
	insinto /usr/share/jupyter/kernels/${PN}
	doins "${FILESDIR}"/kernel.json

	distutils-r1_python_install_all
}