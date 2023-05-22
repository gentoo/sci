# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Flexible DICOM conversion to structured directory layouts"
HOMEPAGE="
	https://github.com/nipy/heudiconv
	https://heudiconv.readthedocs.io/en/latest/
"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/versioningit[${PYTHON_USEDEP}]
	sci-biology/dcm2niix
	sci-biology/dcmstack[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-libs/nipype[${PYTHON_USEDEP}]
	sci-libs/pydicom[${PYTHON_USEDEP}]
	"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

# Reported upstream:
# https://github.com/nipy/heudiconv/issues/679
EPYTEST_DESELECT=(
	heudiconv/tests/test_main.py::test_prepare_for_datalad
)

distutils_enable_tests pytest
