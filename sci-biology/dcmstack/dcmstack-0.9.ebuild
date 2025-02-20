# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1

DESCRIPTION="DICOM to Nifti coversion"
HOMEPAGE="https://dcmstack.readthedocs.org/en/latest/"
SRC_URI="https://github.com/moloney/dcmstack/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-libs/pydicom[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
