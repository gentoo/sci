# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_NO_PARALLEL_BUILD=true

inherit distutils-r1 multilib git-r3 flag-o-matic

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
RDEPEND="${DEPEND}
	sci-libs/nibabel[${PYTHON_USEDEP}]
	>=sci-libs/pydicom-0.9.7[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all
}
