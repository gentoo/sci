# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3 multilib

DESCRIPTION="DICOM to Nifti coversion"
HOMEPAGE="https://dcmstack.readthedocs.org/en/latest/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/moloney/dcmstack"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="sci-libs/nibabel[${PYTHON_USEDEP}]
	>=sci-libs/pydicom-0.9.7[${PYTHON_USEDEP}]"
