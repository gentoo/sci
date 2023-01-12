# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
DISTUTILS_USE_SETUPTOOLS=rdepend

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
	dev-python/mock[${PYTHON_USEDEP}]
	dicom? (
		dev-python/pillow[${PYTHON_USEDEP}]
		sci-libs/pydicom
	)
"

BDEPEND="test? (
	dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
)"

EPYTEST_DESELECT=(
	# Re-evaluate after 3.2.1
	nibabel/gifti/tests/test_parse_gifti_fast.py::test_parse_dataarrays
)

distutils_enable_sphinx doc/source dev-python/texext dev-python/numpydoc dev-python/matplotlib
distutils_enable_tests pytest
