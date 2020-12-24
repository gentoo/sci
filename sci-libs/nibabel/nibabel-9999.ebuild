# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 git-r3

DESCRIPTION="Access a cacophony of neuro-imaging file formats"
HOMEPAGE="http://nipy.org/nibabel/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nibabel.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="dicom doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dicom? (
		sci-libs/pydicom
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
	cd "${BUILD_DIR}" || die
	echo "backend: Agg" > matplotlibrc
	MPLCONFIGDIR=. nosetests || die
}
