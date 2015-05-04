# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit distutils-r1 git-2

DESCRIPTION="Access a cacophony of neuro-imaging file formats"
HOMEPAGE="http://nipy.org/nibabel/"
EGIT_REPO_URI="https://github.com/nipy/nibabel.git"

LICENSE="MIT"
SLOT="0"
IUSE="dicom doc test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dicom? (
		sci-libs/pydicom[${PYTHON_USEDEP}]
		virtual/python-imaging[${PYTHON_USEDEP}]
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
