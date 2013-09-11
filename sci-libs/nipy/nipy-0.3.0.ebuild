# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7,3_2} )
DISTUTILS_NO_PARALLEL_BUILD=true

inherit distutils-r1 eutils multilib flag-o-matic


DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="http://nipy.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.2[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# nipy uses the horrible numpy.distutils automagic
}
