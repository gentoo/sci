# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="Access a cacophony of neuro-imaging file formats"
HOMEPAGE="https://nipy.org/nibabel/"
SRC_URI="https://github.com/nipy/nibabel/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dicom"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dicom? (
		dev-python/pillow[${PYTHON_USEDEP}]
		sci-libs/pydicom
	)
"

BDEPEND="test? (
	dev-python/pytest-httpserver[${PYTHON_USEDEP}]
)"

distutils_enable_sphinx doc/source dev-python/texext dev-python/numpydoc dev-python/matplotlib
distutils_enable_tests pytest
