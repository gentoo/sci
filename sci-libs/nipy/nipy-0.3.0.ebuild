# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_2,3_3} )
DISTUTILS_NO_PARALLEL_BUILD=true

inherit distutils-r1 eutils multilib flag-o-matic

MY_P="nipy-${PV}"

DESCRIPTION="Neuroimaging tools for Python."
HOMEPAGE="http://nipy.org/"
SRC_URI="https://pypi.python.org/packages/source/n/nipy/nipy-0.3.0.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.2[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/sympy-0.6.6[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.2[${PYTHON_USEDEP}]"
DEPEND="
	"

python_prepare_all() {
	# bug #397605
	[[ ${CHOST} == *-darwin* ]] \
		&& append-ldflags -bundle "-undefined dynamic_lookup" \
		|| append-ldflags -shared

	# nipy uses the horrible numpy.distutils automagic
}