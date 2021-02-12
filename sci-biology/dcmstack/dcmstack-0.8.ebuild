# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="DICOM to Nifti coversion"
HOMEPAGE="https://dcmstack.readthedocs.org/en/latest/"
SRC_URI="https://github.com/moloney/dcmstack/archive/v${PV}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/moloney/dcmstack"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-libs/pydicom[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py
