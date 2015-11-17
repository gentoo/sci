# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Access a cacophony of neuro-imaging file formats"
HOMEPAGE="http://nipy.org/nibabel/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nibabel.git"

LICENSE="MIT"
SLOT="0"
IUSE="dicom doc test"
KEYWORDS=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dicom? (
		sci-libs/pydicom[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		)
	"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	"

python_test() {
	distutils-r1_install_for_testing
	cd "${BUILD_DIR}" || die
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. nosetests || die
}
