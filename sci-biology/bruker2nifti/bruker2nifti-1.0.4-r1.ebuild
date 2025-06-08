# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_USE_SETUPTOOLS="rdepend"
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1

DESCRIPTION="Medical image converter, from raw Bruker ParaVision to NIfTI"
HOMEPAGE="https://github.com/SebastianoF/bruker2nifti"
SRC_URI="https://github.com/SebastianoF/bruker2nifti/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<dev-python/numpy-2[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	sed -i -e "s/packages=find_packages()/packages=find_packages(exclude=('test',))/g"\
		setup.py || die
	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest
distutils_enable_sphinx docs
