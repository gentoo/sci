# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

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
	dev-python/mock[${PYTHON_USEDEP}]
	dicom? (
		sci-libs/pydicom[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		)
	"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		)
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	"

python_test() {
	distutils-r1_install_for_testing
	cd "${BUILD_DIR}" || die
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. nosetests || die
}
