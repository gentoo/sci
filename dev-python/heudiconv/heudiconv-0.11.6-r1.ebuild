# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1

DESCRIPTION="Flexible DICOM conversion to structured directory layouts"
HOMEPAGE="
	https://github.com/nipy/heudiconv
	https://heudiconv.readthedocs.io/en/latest/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

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
		dev-python/six[${PYTHON_USEDEP}]
	)
"

# Patch sumbitted upstream, check if removal possible in next release:
# https://github.com/nipy/heudiconv/pull/631
PATCHES=(
	"${FILESDIR}/${P}-gitenv.patch"
)

distutils_enable_tests pytest
