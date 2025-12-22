# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="A pure python package for parsing DICOM files"
HOMEPAGE="https://pydicom.github.io/pydicom/dev/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Reported upstream:
# https://github.com/pydicom/pydicom/issues/1800
RESTRICT="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	distutils-r1_install_for_testing
	py.test -r sx --pyargs pydicom --verbose || die
}
