# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 git-r3

DESCRIPTION="Access a cacophony of neuro-imaging file formats"
HOMEPAGE="https://nipy.org/nibabel/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nibabel.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="dicom"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dicom? (
		sci-libs/pydicom
		dev-python/pillow[${PYTHON_USEDEP}]
		)
"

BDEPEND="test? (
	dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
)"

distutils_enable_sphinx doc/source dev-python/texext dev-python/numpydoc dev-python/matplotlib
distutils_enable_tests pytest
