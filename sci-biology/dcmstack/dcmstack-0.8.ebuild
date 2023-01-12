# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="DICOM to Nifti coversion"
HOMEPAGE="https://dcmstack.readthedocs.org/en/latest/"
SRC_URI="
	https://github.com/moloney/dcmstack/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://resources.chymera.eu/patches/dcmstack-0.8-pytest.patch
"
EGIT_REPO_URI="https://github.com/moloney/dcmstack"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/nibabel[${PYTHON_USEDEP}]
	sci-libs/pydicom[${PYTHON_USEDEP}]
"

PATCHES=( "${DISTDIR}/${P}-pytest.patch" )

distutils_enable_tests pytest
