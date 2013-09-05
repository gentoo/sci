# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits_image/scikits_image-0.8.2.ebuild,v 1.3 2013/06/18 04:33:25 patrick Exp $

EAPI=5

# pyamg missing py3 support
# PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-2

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="http://nipy.sourceforge.net/nipype/"
EGIT_REPO_URI="https://github.com/nipy/nipype"

LICENSE="BSD"
SLOT="0"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.2[${PYTHON_USEDEP}]"
RDEPEND="
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]"

python_test() {
	nosetests -v || die
}


