# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits_image/scikits_image-0.8.2.ebuild,v 1.3 2013/06/18 04:33:25 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2} )
DISTUTILS_NO_PARALLEL_BUILD=true

inherit distutils-r1 multilib git-2 flag-o-matic

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="http://nipy.org/"
EGIT_REPO_URI="https://github.com/nipy/nipy"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS=""

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
